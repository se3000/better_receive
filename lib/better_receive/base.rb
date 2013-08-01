module BetterReceive
  class Base

    def initialize(subject, message, options={}, &block)
      @subject = subject
      @selector = message.is_a?(Hash) ? message : message.to_sym
      @options = options
      @block = block
    end


    private

    attr_reader :subject, :selector, :options, :block

    def subject_is_any_instance?
      defined?(RSpec::Mocks::AnyInstance) && subject.is_a?(RSpec::Mocks::AnyInstance::Recorder)
    end

    def respond_to(selector)
      RSpec::Matchers::BuiltIn::RespondTo.new(selector)
    end

    def any_instance_better_expect(selector, options, &block)
      any_instance_should_respond_to selector
      any_instance_add_expectation selector, &block
    end

    def any_instance_better_not_expect(selector, options, &block)
      any_instance_should_respond_to selector
      any_instance_add_negative_expectation selector, &block
    end

    def any_instance_should_respond_to(selector)
      klass = subject.instance_variable_get(:@klass)
      unless klass.method_defined?(selector)
        raise "Expected instances of #{klass.name} to respond to :#{selector}"
      end
    end

    def any_instance_add_expectation(selector, &block)
      subject.send(:observe!, selector)

      subject.message_chains.add(selector, expectation_chain(selector, &block))
    end

    def any_instance_add_negative_expectation(selector, &block)
      subject.send(:observe!, selector)

      subject.message_chains.add(selector, expectation_chain(selector, &block)).never
    end

  end
end
