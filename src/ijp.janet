(import http)
(import json)


(def search-url "https://api.github.com/search/code?q=extension%3Ajanet+filename%3Aproject.janet")
(def headers {"Authorization" (string "token " (os/getenv "API_TOKEN"))})


(def repos @{})
(def owners @{})


(defn get-repos [response]
  (def body (json/decode (get response :body)))
  (def items (get body "items"))
  (def result (map (fn [x]
                     (def repo (get x "repository"))
                     (unless (get repo "fork")
                       repo))
                   items))
  (filter truthy? result))


(def links-grammar
  '{:url (capture (some (+ :w (set ".+:/%?=&_"))))
    :ws (any :s)
    :relation (capture (some :w))
    :link (sequence "<" :url ">;" :ws "rel=\"" :relation "\"")
    :separator (sequence "," :ws)
    :main (some (sequence :link (? :separator)))})


(defn find-next-link [headers]
  (def link (get headers "link"))
  (def links (peg/match links-grammar link))
  (when (not (nil? links))
    (def index-of-next (find-index (fn [x] (= x "next")) links))
    (if (nil? index-of-next)
      nil
      (get links (- index-of-next 1)))))


(defn main [& args]
  (unless (= 2 (length args))
    (print "Usage: ijp <location>")
    (os/exit 1))

  (var paged-url search-url)

  (forever
    (print "Getting response...")
    (def response (http/get paged-url :headers headers))
    (if (nil? (get-in response [:headers "link"]))
      (do
        (print "Hit secondary rate limit")
        (os/sleep 600)
        (print "Restarting...")
        (set paged-url search-url))
      (do
        (each repo (try (get-repos response)
                        ([err] []))
          (put repos (get repo "id") (get repo "full_name"))
          (put owners (get-in repo ["owner" "id"]) true))
        (set paged-url (find-next-link (get response :headers)))
        (if paged-url
          (os/sleep 20)
          (break)))))

  (def proc (os/spawn ["date" "-R" "-u"] :p {:out :pipe}))
  (:wait proc)
  (def date (string/slice (:read (proc :out) :all) 0 -2))

  (print "The repositories are:"
         (reduce
           (fn [s n] (string s "\n" n))
           ""
           (sort (values repos))))
  (print "The number of unique repos is " (length (keys repos)))
  (print "The number of unique users is " (length (keys owners)))
  (print "Generated at " date)

  (spit (get args 1)
        (json/encode {:num_users (length (keys owners))
                      :num_repos (length (keys repos))
                      :repos     (sort (values repos))
                      :generated date})))
