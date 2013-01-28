require 'spec_helper'

describe BetterReceive::Stub do
  class Foo
    def bar(baz = nil)
    end
  end

  describe "#assert_with" do
    let(:foo) { Foo.new }
    let(:br_stub) { BetterReceive::Stub.new(foo) }

    context "when passed a single selector" do
      context "when checking responds to" do
        it "determines whether an object responds to a method" do
          foo.should_receive(:respond_to?).with(:bar).and_return(true)

          br_stub.assert_with :bar

          foo.bar
        end

        it "raises an error if the method is not defined" do
          expect {
            br_stub.assert_with :bar_baz
          }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
            error.message.should =~ /to respond to :bar_baz/
          }
        end
      end

      context "when stubbing" do
        let(:mock_proxy) { double(RSpec::Mocks::Proxy).as_null_object }
        let(:block_param) { Proc.new {} }
        let(:options) { {passed: true} }

        it "creates a mock proxy and adds an expectation to it" do
          foo.should_receive(:send).with(:__mock_proxy).and_return(mock_proxy)
          mock_proxy.should_receive(:add_stub)

          br_stub.assert_with :bar
        end

        it "returns an rspec message expectation(responds to additional matchers ('with', 'once'...))" do
          br_stub.assert_with(:bar).should be_a RSpec::Mocks::MessageExpectation


          br_stub.assert_with(:bar).with('wibble')
        end

        it "passes all arguments through to the mock_proxy" do
          foo.should_receive(:send).with(:__mock_proxy).and_return(mock_proxy)
          mock_proxy.should_receive(:add_stub) do |*args, &block|
          args[1].should == :bar
          args[2].should == options
          block.should == block_param
          end

          br_stub.assert_with(:bar, passed: true, &block_param)
        end

        it "returns the value passed in the block" do
          br_stub.assert_with(:bar) { :baz }

          foo.bar.should == :baz
        end
      end
    end

    context "when passed a hash" do
      class Foo
        def extra; end
      end

      context "and checking responds to" do
        it "determines whether an object responds to a method" do
          params = {bar: '1', extra: '2'}

          foo.should_receive(:respond_to?).with(:bar).and_return(true)
          foo.should_receive(:respond_to?).with(:extra).and_return(true)

          br_stub.assert_with params
        end

        it "raises an error if the method is not defined" do
          params = {bar: '1', baz: '2'}

          expect{
            br_stub.assert_with params
          }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
            error.message.should =~ /to respond to :baz/
          }
        end
      end

      context "and stubbing" do
        it 'stubs out each method' do
          params = {bar: '1', extra: '2'}
          br_stub.assert_with params

          foo.bar.should == '1'
          foo.extra.should == '2'
        end
      end
    end

    context "on .any_instance" do
      let(:br_stub) { BetterReceive::Stub.new(Foo.any_instance) }

      context "when the method is defined" do
        it 'stubs the method out' do
          br_stub.assert_with(:bar).and_return(:whatever)

          foo.bar.should == :whatever
        end
      end

      context 'when the method is not defined' do
        it 'raises an error' do
          expect {
            br_stub.assert_with(:baz)
          }.to raise_error { |error|
            error.message.should == "Expected instances of Foo to respond to :baz"
          }
        end
      end
    end
  end
end
