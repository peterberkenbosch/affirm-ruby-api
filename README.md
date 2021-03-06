# Affirm Ruby API

Clean, fast and pure Ruby implementation for the [Affirm API](https://docs.affirm.com/affirm-developers/reference)

This is using the new Transaction API and is not compatible with the Charge API. Also see the [Affirm Changelog](https://docs.affirm.com/affirm-developers/changelog/transactions-api)

[![Gem Version](https://badge.fury.io/rb/affirm-ruby-api.svg)](https://badge.fury.io/rb/affirm-ruby-api)
![Tests](https://github.com/peterberkenbosch/affirm-ruby-api/workflows/Tests/badge.svg)
![StandardRB](https://github.com/peterberkenbosch/affirm-ruby-api/workflows/StandardRB/badge.svg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'affirm-ruby-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install affirm-ruby-api

## Documentation

* [Official documentation](https://peterberkenbosch.gitbook.io/affirm-ruby-api)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing support

When implementing this gem into your application or other gem, you can reuse the JSON and HTTP payloads and responses. For example with RSpec you can add the following to your `spec_helper.rb` file:

```ruby
require "affirm/testing_support/http_responses"

RSpec.configure do |config|
  config.include Affirm::TestingSupport::HttpResponses
end
```

this will provide you with the `read_http_fixture` and `read_json_fixture` methods. These can be used to mock the responses and payload body's with `WebMock`.

For details on how to use this, take a look at the usage in the spec files here.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/peterberkenbosch/affirm-ruby-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/peterberkenbosch/affirm-ruby-api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Affirm::Ruby::Api project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/peterberkenbosch/affirm-ruby-api/blob/master/CODE_OF_CONDUCT.md).
