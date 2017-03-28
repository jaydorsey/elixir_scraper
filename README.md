# Scraper

A simple Elixir scraper demo. This logs into a utility account & navigates
you to the history page. Just an example of using Elixir/Hound to scrape
a website along with some custom Chrome options

```
# Clone this repo, then:
brew install elixir # installs erlang & elixir
brew install rust # for compiling html5ever
brew install chromedriver
mix local.hex # installs hex

export DOM_USERNAME="username"
export DOM_PASSWORD="password"

mix deps.get # get dependencies

# Start PhantomJS web driver if using PhantomJS. I recommend you use Chrome
# instead
phantomjs --wd

# Compile & run the application
iex -S mix
```

From the iex REPL:

```
Scraper.start

# Do your stuff in iex here
# Use reload() to live recompile changes to your module

Scraper.stop # close browser
```

# References & reading

- https://github.com/philss/floki
- https://github.com/HashNuke/hound
- https://lord.io/blog/2015/elixir-scraping/
