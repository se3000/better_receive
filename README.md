# BetterReceive

BetterReceive helps test drive new functionality and prevent bugs by asserting that an object responds to a method before mocking it.

## Installation

    $ gem install better_receive

## Usage


```ruby
class Foo; end
foo = Foo.new

foo.better_receive(:bar)
```
or
```ruby
Foo.any_instance.better_receive(:bar)
```

Either situation will raise an error because instances of Foo do not respond to :bar.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do

* #better_stub
* support arrity checks with #responds_to
* support options other than Ruby 1.9.2+ and RSpec

