require "better_receive/version"
require "better_receive/mock"

module BetterReceive
  def better_receive(*args)
    Mock.new(self).responds_to_and_receives(*args)
  end
end

BasicObject.class_eval { include BetterReceive }
