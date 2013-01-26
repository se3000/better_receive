require 'spec_helper'

describe BetterReceive do
  class Foo
    def bar; end
  end

  describe "#better_receive" do
    let(:foo) { Foo.new }
    let(:br_instance) { double(BetterReceive::Mock).as_null_object }

    it "passes the object being mocked into a new BetterReceive::Mock instance" do
      BetterReceive::Mock.should_receive(:new).with(foo).and_return(br_instance)

      foo.better_receive(:bar)
    end

    it "checks that the object responds to the method and that the method is called" do
      BetterReceive::Mock.stub(:new).with(foo).and_return(br_instance)

      br_instance.should_receive(:responds_to_and_receives).with(:bar)

      foo.better_receive(:bar)
    end
  end
end
