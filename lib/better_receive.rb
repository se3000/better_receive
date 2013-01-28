require "better_receive/version"
require "better_receive/base"
require "better_receive/mock"
require "better_receive/stub"

module BetterReceive
  def better_receive(*args, &block)
    Mock.new(self).assert_with(*args, &block)
  end

  def better_stub(*args, &block)
    Stub.new(self).assert_with(*args, &block)
  end
end

BasicObject.class_eval { include BetterReceive }
