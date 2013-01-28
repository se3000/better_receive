require "better_receive/version"
require "better_receive/base"
require "better_receive/mock"
require "better_receive/stub"

module BetterReceive
  def better_receive(*args)
    Mock.new(self).responds_to_and_receives(*args)
  end

  def better_stub(*args)
    Stub.new(self).assert_and_stub(*args)
  end
end

BasicObject.class_eval { include BetterReceive }
