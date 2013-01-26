module BetterReceive
  class Mock

    def initialize(object)
      @object = object
    end

    def responds_to_and_receives(selector, options, &block)
      better_respond_to(selector)

      mock_method(selector, options, &block)
    end

    private

    attr_reader :object

    def better_respond_to(selector)
      if any_instance?
        any_instance_should_respond_to selector
      else
        object.should respond_to(selector)
      end
    end

    def any_instance_should_respond_to(selector)
      klass = object.instance_variable_get(:@klass)
      unless klass.method_defined?(selector)
        raise "Expected instances of #{klass.name} to respond to :#{selector}"
      end
    end

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

    def mock_method(selector, options, &block)
      if any_instance?
        any_instance_should_receive selector, &block
      else
        location = options[:expected_from] || caller(1)[2]
        mock_proxy.add_message_expectation(location, selector, options, &block)
      end
    end

    def any_instance_should_receive(selector, &block)
      RSpec::Mocks::space.add(object)

      object.instance_variable_set(:@expectation_set, true)
      object.send(:observe!, selector)

      object.message_chains.add(selector, expectation_chain(selector, &block))
    end

    def expectation_chain(*args)
      if defined?(RSpec::Mocks::AnyInstance::PositiveExpectationChain)
        RSpec::Mocks::AnyInstance::PositiveExpectationChain.new(*args)
      else
        RSpec::Mocks::AnyInstance::ExpectationChain.new(*args)
      end
    end

    def any_instance?
      object.is_a?(RSpec::Mocks::AnyInstance::Recorder)
    end

    def mock_proxy
      @mock_proxy ||= object.send(:__mock_proxy)
    end

  end
end
