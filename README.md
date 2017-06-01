# Shafunge

An interpreter for [Befunge](http://esolangs.org/wiki/Befunge) implemented
in Ruby.

## Installation/usage

Run this command in your terminal (if I end up putting this on RubyGems):

```ruby
gem install shafunge
```

And then execute:

    $ shafunge path/to/program.bf

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
The console script defines a `run` function that takes the path to a Befunge program and runs it.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sharparam/shafunge.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
