require "better_receive/version"
require "better_receive/base"
require "better_receive/mock"
require "better_receive/stub"

module BetterReceive
  def better_receive(*args)
    Mock.new(self).assert_with(*args)
  end

  def better_stub(*args)
    Stub.new(self).assert_with(*args)
  end
end

BasicObject.class_eval { include BetterReceive }
