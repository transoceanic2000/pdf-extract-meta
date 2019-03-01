# PDF::Extract

This gem provides a command line interface to extract field and annotation metadata from a PDF.

```
bin/pdf-extract fields spec/data/field-examples/text.pdf
[{"name":"Sample Text Field","value":"Hello"},{"name":"Sample Text Field (required)","value":null}]
```

```
bin/pdf-extract annotations spec/data/annotation-examples/note.pdf
[{"name":null,"contents":"Hello"},{"name":null,"contents":"Hello"}]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf-extract'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdf-extract

## Usage

Run `bin/pdf-extract --help` for usage.

From within Ruby:
```
Bundler.with_clean_env do
  JSON.parse(`pdf-extract fields '#{pdf_path}'`)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version and push git commits and tags.
