module BetterReceive
  class Mock

    def initialize(object)
      @object = object
    end

    def verify(selector, options, &block)
      better_respond_to(selector)

      mock_method(selector, options, &block)
    end

    private

    attr_reader :object

    def better_respond_to(selector)
      object.should respond_to(selector)
    end

    def mock_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      mock_proxy.add_message_expectation(location, selector, options, &block)
    end

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

    def mock_proxy
      @mock_proxy ||= object.send(:__mock_proxy)
    end

  end
end
