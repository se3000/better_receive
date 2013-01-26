require 'spec_helper'

describe BetterReceive do
  class Foo
    def bar(baz = nil)
    end
  end

  describe "#responds_to_and_receives" do
    let(:foo) { Foo.new }
    let(:br_mock) { BetterReceive::Mock.new(foo) }

    it "determines whether an object responds to a method" do
      foo.should_receive(:respond_to?).with(:bar).and_return(true)

      br_mock.responds_to_and_receives :bar

      foo.bar
    end

    it "raises an error if it the method is not defined" do
      expect {
        br_mock.responds_to_and_receives :bar_baz
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
        error.message.should =~ /to respond to :bar_baz/
      }
    end

    context "when mocking" do
      let(:mock_proxy) { double(RSpec::Mocks::Proxy) }

      it "creates a mock proxy and adds an expectation to it" do
        foo.should_receive(:send).with(:__mock_proxy).and_return(mock_proxy)
        mock_proxy.should_receive(:add_message_expectation)

        br_mock.responds_to_and_receives :bar
      end

      it "returns an rspec message expectation(responds to additional matchers ('with', 'once'...))" do
        foo.better_receive(:bar).should be_a RSpec::Mocks::MessageExpectation

        foo.bar

        br_mock.responds_to_and_receives(:bar).with('wibble')

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

          br_mock.responds_to_and_receives(:bar, passed: true, &block_param)
        end
      end

      context "on .any_instance" do
        let(:br_mock) { BetterReceive::Mock.new(Foo.any_instance) }

        context "when the method is defined" do
          context "and the method is called" do
            it 'does not raise an error' do
              expect {
                br_mock.responds_to_and_receives(:bar)
                foo.bar
              }.to_not raise_error
            end
          end

          context 'and the method is not called' do
            it 'does raise an error' do
              expect {
                br_mock.responds_to_and_receives(:bar)
                RSpec::Mocks::space.verify_all
              }.to raise_error(RSpec::Mocks::MockExpectationError) { |error|
                error.message.should == "Exactly one instance should have received the following message(s) but didn't: bar"
              }
            end
          end
        end

        context 'when the method is not defined' do
          it 'raises an error' do
            expect {
              br_mock.responds_to_and_receives(:baz)
            }.to raise_error { |error|
              error.message.should == "Expected instances of Foo to respond to :baz"
            }
          end
        end
      end
    end
  end
end
