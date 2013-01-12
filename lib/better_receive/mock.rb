module BetterReceive
  class Mock

    def initialize(object)
      @object = object
    end

    def verify(selector, *args, &block)
      @object.should respond_to(selector)

      mock_method(selector, *args, &block)
    end

    def mock_method(selector, *args, &block)
      @mock ||= @object.should_receive(selector, *args, &block)
    end

    private

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

  end
end
