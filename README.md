# EpiDoc Validator

JRuby library for validating [EpiDoc XML](https://sourceforge.net/p/epidoc/wiki/Home/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'epi_doc_validator'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install epi_doc_validator
```

(See project at [rubygems.org](https://rubygems.org/gems/epi_doc_validator))

## Requirements

* JRuby >= 9.2.9

## Usage

```ruby
require 'epi_doc_validator'

validator = EpiDocValidator::Validator.new
xml = File.read('my-epi-doc-file.xml')

# Validate against latest schema
validator.valid?(xml) # => `true` or `false`

# Validate against a specific schema version
validator.valid?(xml, version: '9.1') # => `true` or `false`
                                      # => raises exception if version doesn't exist

# Get list of versions
validator.versions # => `["8", "8-rc1", "8.2", ... , "dev", "latest"]`

# Validate and return a list of errors
validator.valid?(xml) # => array of errors (`[]` if valid)

# Validate and return a list of errors for a specific schema version
validator.valid?(xml, version: '9.1') # => array of errors (`[]` if valid)
                                      # => raises exception if version doesn't exist
```

## Development

### Setup

* `bundle install`

### Running tests

* `bundle exec rspec`

### Linting the code

* `bundle exec rubocop`

### Updating schemas

* `bash scripts/update-schema.sh` (requires `wget`)

### Publishing

* Bump version in `lib/epi_doc_validator/version.rb`
* Commit and push to GitHub
* On GitHub, create a new release
* Run `gem build epi_doc_validator.gemspec`
* Run `gem push epi_doc_validator-X.Y.Z-java.gem`

## Notes

Currently, the library only works with JRuby.
All of the code in *this* repository works with both Ruby MRI and JRuby.
In the future we hope to release a version that works with Ruby MRI.

The problem is that the EpiDoc schema is written in something called RELAX NG.
Nokogiri, the main XML processing library for Ruby, uses `libxml2` with Ruby MRI
and `jing` with JRuby. `jing` works correctly, but there are at least two long-standing
bugs in `libxml2`'s RELAX NG validation code.
Until these are fixed, this library is too unstable with Ruby MRI to release.

List of (known) bugs:

* 2008: "RNG internal error trying to compile notAllowed" warning is printed multiple times ([link](https://mail.gnome.org/archives/xml/2008-June/msg00087.html))
* 2012: Validation never terminates on occasion ([link](https://github.com/sparklemotion/nokogiri/issues/806))

For a more detailed explanation of this problem in a slightly different domain,
see Hugh Cayless's post [Experiment: is the JavaScript port of libxml2 viable?](https://github.com/hcayless/brackets/blob/master/experiment_1.md):

> Result: Inconclusive; lean towards endless screaming.
