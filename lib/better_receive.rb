require "better_receive/version"
require "better_receive/mock"

module BetterReceive
  def better_receive(method_name, options={}, &block)
    Mock.new(self).verify(method_name, options, &block)
  end
end

BasicObject.class_eval { include BetterReceive }
