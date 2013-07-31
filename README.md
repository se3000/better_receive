[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/se3000/better_receive)
# BetterReceive

Test drive new functionality and prevent bugs by asserting objects respond to methods when mocking/stubbing.

## Installation

    $ gem install better_receive

## Usage

```ruby

class Foo; end
foo = Foo.new

foo.better_receive(:bar)
# or
foo.better_stub(bar: 1, baz: 2)
# or
Foo.any_instance.better_receive(:bar).with(:wibble)
# or
foo.better_not_receive(:bar_baz)

```

Any of these situation will raise an error because instances of Foo do not respond to :bar.

After the initial extra assertion, they continue to act like regular RSpec mocks/stubs.


If you are using a version of RSpec < 2.14, lock to BetterReceive version 0.5 or earlier.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do

* support arrity checks with #responds_to
* support options other than Ruby 1.9.2+ and RSpec

