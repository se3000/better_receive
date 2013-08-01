require "better_receive/version"
require "better_receive/base"
require "better_receive/mock"
require "better_receive/stub"

module BetterReceive
  def better_receive(selector, options={}, &block)
    Mock.new(self, selector, options, &block).assert
  end

  def better_not_receive(selector, options={}, &block)
    Mock.new(self, selector, options, &block).assert_negative
  end

  def better_stub(selector, options={}, &block)
    Stub.new(self, selector, options, &block).assert
  end
end

BasicObject.class_eval { include BetterReceive }
