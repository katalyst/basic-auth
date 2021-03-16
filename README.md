# Katalyst::Basic::Auth

This gem provides rails middleware to request basic authentication site-wide.
The middleware is enabled when the environment variable KATALYST_BASIC_AUTH_ENABLED is set.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'katalyst-basic-auth'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install katalyst-basic-auth

## Usage

Add the gem to your project:

    $ bundler add katalyst-basic-auth

Configure the following environment variables to control basic auth

| Environment Variable | Description |
| ------ | ----- |
| KATALYST_BASIC_AUTH_ENABLED | If defined the basic auth middleware will be enabled |
| KATALYST_BASIC_AUTH_USER | The username for basic authentication. Default is the app name in lowercase |
| KATALYST_BASIC_AUTH_PASS | The password for basic authentication. A password will be generated if not set |

The gem provides a rake task that can be used to query basic auth settings:

    $ rake katalyst_basic_auth:info  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katalyst/katalyst-basic-auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/katalyst-basic-auth/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the katalyst-basic-auth project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/katalyst-basic-auth/blob/master/CODE_OF_CONDUCT.md).
