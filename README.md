# Allen

CLI and Rake tools for quickly building and managing Umbraco projects

[![Build Status](https://secure.travis-ci.org/imulus/allen.png)](http://travis-ci.org/imulus/allen)

## Installation

Add this line to your application's Gemfile:

    gem 'allen'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install allen

## Usage

### CLI

    $ allen new [project]
TODO: Write CLI usage instructions here

### Rake

`Rakefile`

```ruby
require 'allen/rake'

settings do
  client "ClientName"
end

project "ProjectName"
project "OtherProjectName"

define_tasks
```


```bash
$ rake -T
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
