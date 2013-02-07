module BetterReceive
  class Base

    def initialize(subject)
      @subject = subject
    end


    private

    attr_reader :subject

    def subject_is_any_instance?
      defined?(RSpec::Mocks::AnyInstance) && subject.is_a?(RSpec::Mocks::AnyInstance::Recorder)
    end

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

    def subject_mock_proxy
      @mock_proxy ||= subject.send(:__mock_proxy)
    end

    def any_instance_better_expect(selector, options, &block)
      any_instance_should_respond_to selector
      any_instance_add_expectation selector, &block
    end

    def any_instance_should_respond_to(selector)
      klass = subject.instance_variable_get(:@klass)
      unless klass.method_defined?(selector)
        raise "Expected instances of #{klass.name} to respond to :#{selector}"
      end
    end

    def any_instance_add_expectation(selector, &block)
      RSpec::Mocks::space.add(subject)

      subject.instance_variable_set(:@expectation_set, true)
      subject.send(:observe!, selector)

      subject.message_chains.add(selector, expectation_chain(selector, &block))
    end

  end
end
