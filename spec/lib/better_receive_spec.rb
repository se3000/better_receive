require 'spec_helper'

describe BetterReceive do
  class Foo
    def bar; end
  end

  describe "#better_receive" do
    let(:foo) { Foo.new }
    let(:br_instance) { double(BetterReceive::Mock).as_null_object }

    it "passes the object being mocked into a new BetterReceive::Mock instance" do
      BetterReceive::Mock.should_receive(:new).with(foo, :bar, {}).and_return(br_instance)

      foo.better_receive(:bar)
    end

    it "checks that the object responds to the method and that the method is called" do
      BetterReceive::Mock.stub(:new).with(foo, :bar, {}).and_return(br_instance)

      br_instance.should_receive(:assert)

      foo.better_receive(:bar)
    end

    it "returns an RSpec expectation object" do
      foo.better_receive(:bar).should be_a RSpec::Mocks::MessageExpectation

      foo.bar


      foo.better_receive(:bar).with('wibble')

      foo.bar('wibble')
    end

    it "returns the value of the block passed in" do
      foo.better_receive(:bar) { :baz }

      foo.bar.should == :baz
    end
  end

  describe "#better_stub" do
    let(:foo) { Foo.new }
    let(:br_instance) { double(BetterReceive::Stub).as_null_object }

    it "passes the object being stubbed into a new BetterReceive::Stub instance" do
      BetterReceive::Stub.should_receive(:new).with(foo, :bar, {}).and_return(br_instance)

      foo.better_stub(:bar)
    end

    it "checks that the object responds to the method and that the method is called" do
      BetterReceive::Stub.stub(:new).with(foo, :bar, {}).and_return(br_instance)

      br_instance.should_receive(:assert)

      foo.better_stub(:bar)
    end

    it "returns an RSpec expectation object" do
      foo.better_stub(:bar).should be_a RSpec::Mocks::MessageExpectation

      foo.bar


      foo.better_stub(:bar).with('wibble')

      foo.bar('wibble')
    end

    it "returns the value of the block passed in" do
      foo.better_stub(:bar) { :baz }

      foo.bar.should == :baz
    end
  end
end
