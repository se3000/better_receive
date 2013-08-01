require 'spec_helper'

describe BetterReceive::Mock do
  class Foo
    def bar(baz = nil)
    end
  end

  describe "#assert" do
    let(:foo) { Foo.new }
    let(:selector) { :bar }
    let(:br_mock) { BetterReceive::Mock.new(foo, selector) }

    it "determines whether an object responds to a method" do
      foo.should_receive(:respond_to?).with(:bar).and_return(true)

      br_mock.assert

      foo.bar
    end

    context "when the method is not defined" do
      let(:selector) { :bar_baz }

      it "raises an error if the method is not defined" do
        expect {
          br_mock.assert
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
          error.message.should =~ /to respond to :bar_baz/
        }
      end
    end

    it "returns an rspec message expectation" do
      foo.better_receive(:bar).should be_a RSpec::Mocks::MessageExpectation

      foo.bar
    end

    it "responds to additional matchers(:with, :once...)" do
      br_mock.assert.with('wibble')

      foo.bar('wibble')
    end

    context "passing arguments" do
      let(:selector) { :bar }
      let(:options) { {passed: true} }
      let(:block_param) { Proc.new {} }
      let(:br_mock) { BetterReceive::Mock.new(foo, selector, options, &block_param) }

      before do
        br_mock.assert

        @expectation = RSpec::Mocks.proxy_for(foo).send(:method_doubles)[0][:expectations][0]
      end

      after do
        foo.bar
      end

      it "passes all arguments through to the mock_proxy" do
        @expectation.message.should == :bar
        @expectation.implementation.inner_action.should == block_param
        @expectation.send(:error_generator).opts.should == options
      end

      context "when the selector is a string" do
        let(:selector) { "bar" }

        it "converts the selector to a symbol" do
          @expectation.message.should == selector.to_sym
        end
      end
    end

    context "on .any_instance" do
      let(:selector) { :bar }
      let(:br_mock) { BetterReceive::Mock.new(Foo.any_instance, selector) }

      context "when the method is defined" do
        context "and the method is called" do
          it 'does not raise an error' do
            expect {
              br_mock.assert
              foo.bar
            }.to_not raise_error
          end
        end

        context 'and the method is not called' do
          it 'does raise an error' do
            expect {
              br_mock.assert
              RSpec::Mocks::space.verify_all
            }.to raise_error(RSpec::Mocks::MockExpectationError) { |error|
              error.message.should == "Exactly one instance should have received the following message(s) but didn't: bar"
            }
          end
        end
      end

      context 'when the method is not defined' do
        let(:selector) { :baz }

        it 'raises an error' do
          expect {
            br_mock.assert
          }.to raise_error { |error|
            error.message.should == "Expected instances of Foo to respond to :baz"
          }
        end
      end
    end
  end

  describe "#assert_negative" do
    let(:foo) { Foo.new }
    let(:selector) { :bar }
    let(:br_mock) { BetterReceive::Mock.new(foo, selector) }

    context "when the method is not defined" do
      let(:selector) { :bar_baz }
      it "raises an error" do
        expect {
          br_mock.assert_negative
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
          error.message.should =~ /to respond to :bar_baz/
        }
      end
    end

    it "returns an rspec message expectation" do
      br_mock.assert_negative.should be_a RSpec::Mocks::MessageExpectation

      expect {
        foo.bar
      }.to raise_error(RSpec::Mocks::MockExpectationError) { |error|
        error.message.should include "received: 1 time"
      }
    end

    it "responds to additional matchers(:with, :once...)" do
      br_mock.assert_negative.with('wibble')
      expect {
        foo.bar('wibble')
      }.to raise_error(RSpec::Mocks::MockExpectationError) { |error|
        error.message.should include "received: 1 time"
      }
    end

    context "passing arguments" do
      let(:selector) { :bar }
      let(:options) { {passed: true} }
      let(:block_param) { Proc.new {} }
      let(:br_mock) { BetterReceive::Mock.new(foo, selector, options, &block_param) }

      before do
        br_mock.assert_negative

        @expectation = RSpec::Mocks.proxy_for(foo).send(:method_doubles)[0][:expectations][0]
      end

      it "passes all arguments through to the mock_proxy" do
        @expectation.message.should == :bar
        @expectation.implementation.inner_action.should == block_param
        @expectation.send(:error_generator).opts.should == options
      end

      context "when the selector is a string" do
        let(:selector) { "bar" }

        it "converts the selector to a symbol" do
          @expectation.message.should == selector.to_sym
        end
      end
    end

    context "on .any_instance" do
      let(:selector) { :bar }
      let(:br_mock) { BetterReceive::Mock.new(Foo.any_instance, selector) }

      it 'raises when called' do
        expect {
          br_mock.assert_negative
          foo.bar
        }.to raise_error(RSpec::Mocks::MockExpectationError) { |error|
          error.message.should include "received: 1 time"
        }
      end

      it 'does not raise an error if not called' do
        expect {
          br_mock.assert_negative
          RSpec::Mocks::space.verify_all
        }.to_not raise_error
      end

      context 'when the method is not defined' do
        let(:selector) { :baz }
        it 'raises an error' do
          expect {
            br_mock.assert_negative
          }.to raise_error { |error|
            error.message.should == "Expected instances of Foo to respond to :baz"
          }
        end
      end
    end
  end
end
