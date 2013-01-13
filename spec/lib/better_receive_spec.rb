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

    context "when mocking" do
      let(:mock_proxy) { double(RSpec::Mocks::Proxy) }

      it "creates a mock proxy and adds an expectation to it" do
        foo.should_receive(:send).with(:__mock_proxy).and_return(mock_proxy)
        mock_proxy.should_receive(:add_message_expectation)

        foo.better_receive(:bar)
      end

      it "returns an rspec message expectation(responds to additional matchers ('with', 'once'...))" do
        foo.better_receive(:bar).should be_a RSpec::Mocks::MessageExpectation

        foo.bar

        foo.better_receive(:bar).with('wibble')

        foo.bar('wibble')
      end

      context "and passing arguments" do
        let(:block_param) { Proc.new {} }
        let(:options) { {passed: true} }

        it "passes all arguments through to the mock_proxy" do
          foo.should_receive(:send).with(:__mock_proxy).and_return(mock_proxy)
          mock_proxy.should_receive(:add_message_expectation) do |*args, &block|
            args[1].should == :bar
            args[2].should == options
            block.should == block_param
          end

          foo.better_receive(:bar, passed: true, &block_param)
        end
      end
    end
  end
end
