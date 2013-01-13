module BetterReceive
  class Mock
    attr_reader :expectation, :object

    def initialize(object)
      @object = object
    end

    def verify(selector, options, &block)
      object.should respond_to(selector)

      mock_method(selector, options, &block)
    end

    private

    def mock_method(selector, options, &block)
      mock_proxy = object.send(:__mock_proxy)

      location = options[:expected_from] || caller(1)[2]
      @expectation = mock_proxy.add_message_expectation(location, selector, options, &block)
    end

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

  end
end
