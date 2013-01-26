module BetterReceive
  class Mock

    def initialize(subject)
      @subject = subject
    end

    def responds_to_and_receives(selector, options, &block)
      if subject.is_a?(RSpec::Mocks::AnyInstance::Recorder)
        any_instance_better_receive(selector, options, &block)
      else
        subject.should respond_to selector
        mock_subject_method(selector, options, &block)
      end
    end


    private

    attr_reader :subject

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

    def mock_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      subject_mock_proxy.add_message_expectation(location, selector, options, &block)
    end

    def subject_mock_proxy
      @mock_proxy ||= subject.send(:__mock_proxy)
    end

    def any_instance_better_receive(selector, options, &block)
      any_instance_should_respond_to selector
      any_instance_should_receive selector, &block
    end

    def any_instance_should_respond_to(selector)
      klass = subject.instance_variable_get(:@klass)
      unless klass.method_defined?(selector)
        raise "Expected instances of #{klass.name} to respond to :#{selector}"
      end
    end

    def any_instance_should_receive(selector, &block)
      RSpec::Mocks::space.add(subject)

      subject.instance_variable_set(:@expectation_set, true)
      subject.send(:observe!, selector)

      subject.message_chains.add(selector, expectation_chain(selector, &block))
    end

    def expectation_chain(*args)
      if defined?(RSpec::Mocks::AnyInstance::PositiveExpectationChain)
        RSpec::Mocks::AnyInstance::PositiveExpectationChain.new(*args)
      else
        RSpec::Mocks::AnyInstance::ExpectationChain.new(*args)
      end
    end

  end
end
