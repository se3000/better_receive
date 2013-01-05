require 'spec_helper'

describe BetterReceive do
  class Foo
    def bar(baz = nil)
    end
  end

  describe "#better_receive" do
    let(:foo) { Foo.new }

    it "determines whether an object responds to a method" do
      foo.should_receive(:respond_to?).with(:bar).and_call_original

      foo.better_receive(:bar)

      foo.bar
    end

    it "raises an error if it the method is not defined" do
      expect {
        foo.better_receive(:bar_baz)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
        error.message.should =~ /to respond to :bar_baz/
      }
    end

    it "checks that the object receives the specified method" do
      foo.should_receive(:should_receive).and_call_original

      foo.better_receive(:bar)

      foo.bar
    end

    it "returns an rspec mock object(responds to additional matchers ('with', 'once'...))" do
      foo.better_receive(:bar).should be_a RSpec::Mocks::MessageExpectation

      foo.bar

      foo.better_receive(:bar).with('wibble')

      foo.bar('wibble')
    end

    context "when passing arguments" do
      it "passes all arguments through to should_receive" do
        arg1 = 1
        arg2 = 2
        block = Proc.new {}

        foo.should_receive(:should_receive).with(:bar, arg1, arg2, block)

        foo.better_receive(:bar, arg1, arg2, block)
      end
    end
  end
end
