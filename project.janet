(declare-project
  :name "Is Janet Popular?"
  :description "A site that checks how many people are using Janet on GitHub"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/is-janet-popular"
  :repo "git+https://github.com/pyrmont/is-janet-popular"
  :dependencies ["https://github.com/janet-lang/circlet"
                 "https://github.com/janet-lang/json"
                 "https://github.com/janet-lang/spork"
                 "https://github.com/joy-framework/http"])


(declare-executable
  :name "ijp"
  :entry "src/ijp.janet")
