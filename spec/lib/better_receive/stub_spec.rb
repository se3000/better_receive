require 'spec_helper'

describe BetterReceive::Stub do
  class Foo
    def bar(baz = nil)
    end
  end

  describe "#assert" do
    let(:foo) { Foo.new }
    let(:selector) { :bar }
    let(:br_stub) { BetterReceive::Stub.new(foo, selector) }

    context "when passed a single selector" do
      it "determines whether an object responds to a method" do
        foo.should_receive(:respond_to?).with(:bar).and_return(true)

        br_stub.assert

        foo.bar
      end

      context "when the method is not defined" do
        let(:selector) { :bar_baz }
        it "raises an error" do
          expect {
            br_stub.assert
          }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
            error.message.should =~ /to respond to :bar_baz/
          }
        end
      end

      it "returns an rspec message expectation(responds to additional matchers ('with', 'once'...))" do
        br_stub.assert.should be_a RSpec::Mocks::MessageExpectation

        br_stub.assert.with('wibble')
      end

      context "when passing arguments" do
        let(:selector) { :bar }
        let(:options) { {passed: true} }
        let(:block_param) { Proc.new { "returned value" } }
        let(:br_stub) { BetterReceive::Stub.new(foo, selector, options, &block_param) }

        before do
          br_stub.assert

          @stub = RSpec::Mocks.proxy_for(foo).send(:method_doubles)[0][:stubs][0]
        end

        it "creates a mock proxy and adds an expectation to it" do
          @stub.message.should == :bar
          @stub.implementation.inner_action.should == block_param
          @stub.send(:error_generator).opts.should == options
        end

        it "returns the value passed in the block" do
          br_stub.assert

          foo.bar.should == block_param.call
        end

        context "when the selector is a string" do
          let(:selector) { "bar" }

          it "converts the selector to a symbol" do
            @stub.message.should == selector.to_sym
          end
        end
      end
    end

    context "when passed a hash" do
      class Foo
        def extra; end
      end

      it "determines whether an object responds to a method" do
        br_stub = BetterReceive::Stub.new(foo, {bar: '1', extra: '2'})

        foo.should_receive(:respond_to?).with(:bar).and_return(true)
        foo.should_receive(:respond_to?).with(:extra).and_return(true)

        br_stub.assert
      end

      it "raises an error if the method is not defined" do
        br_stub = BetterReceive::Stub.new(foo, {bar: '1', baz: '2'})

        expect{
          br_stub.assert
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError) { |error|
          error.message.should =~ /to respond to :baz/
        }
      end

      context "and stubbing" do
        it 'stubs out each method' do
          br_stub = BetterReceive::Stub.new(foo, {bar: '1', extra: '2'})
          br_stub.assert

          foo.bar.should == '1'
          foo.extra.should == '2'
        end
      end
    end

    context "on .any_instance" do
      let(:selector) { :bar }
      let(:br_stub) { BetterReceive::Stub.new(Foo.any_instance, selector) }

      context "when the method is defined" do
        it 'stubs the method out' do
          br_stub.assert.and_return(:whatever)

          foo.bar.should == :whatever
        end

        it "does not blow up if the method is not called" do
          br_stub.assert
        end
      end

      context 'when the method is not defined' do
        let(:selector) { :baz }

        it 'raises an error' do
          expect {
            br_stub.assert
          }.to raise_error { |error|
            error.message.should == "Expected instances of Foo to respond to :baz"
          }
        end
      end
    end
  end
end
