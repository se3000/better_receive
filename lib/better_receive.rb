require "better_receive/version"

module BetterReceive
  def better_receive(method_name, *args, &block)
    self.should RSpec::Matchers::BuiltIn::RespondTo.new(method_name)

    self.should_receive(method_name, *args, &block)
  end
end

BasicObject.class_eval  { include BetterReceive }
