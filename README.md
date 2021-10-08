# Is Janet Popular?

Do you spend your nights staring at the ceiling wondering how many unique
repositories there are on GitHub that use the [Janet][] programming language?
Probably not because who would do that? It's super weird.

[Janet]: https://janet-lang.org/ "The official website of the Janet programming language"

But _if_ you did that, you might be frustrated (and also really tired). Fortunately
relief is at hand. The `ijp` executable produced from this repository will scour
GitHub and do its best to not only calculate the number of repositories but compile a list
of said repositories. Huzzah!

## Usage

### For the Impatient

If you're impatient, you can go [here][json-file] to view a JSON file listing the results.
I run the script weekly and the date the results were generated is stored in the JSON object.

[json-file]: https://inqk.net/files/is_janet_popular.json "JSON file of results"

### For the Diligent

Do the following:

```sh
$ git clone git://github.com/pyrmont/is-janet-popular.git
$ cd is-janet-popular
$ jpm deps
$ API_TOKEN=<GitHub API Token> jpm build
$ ./build/ijp "output.json"
```

#### GitHub API Token

The `ijp` executable depends on a [GitHub API token][token]. You can create your own token [here][dashboard].

[token]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token "Help page on creating a Personal Access Token on GitHub"

[dashboard]: https://github.com/settings/tokens "The GitHub page for managing Personal Access Tokens"

## Credits

The code for this project was inspired by [Is Janet There Yet?][ijty] by [Paweł Świątkowski][katafrakt].

[ijty]: https://github.com/katafrakt/isjanetthereyet "The GitHub repository for 'Is Janet There Yet?'"

[katafrakt]: https://github.com/katafrakt "The GitHub profile page for @katafrakt"
