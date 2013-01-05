require "better_receive/version"

module BetterReceive
  def better_receive(method_name, *args, &block)
    self.respond_to?(method_name).should == true
    self.should_receive(method_name, *args, &block)
  end
end

BasicObject.class_eval  { include BetterReceive }
