module BetterReceive
  class Mock < Base

    def assert_with(selector, options={}, &block)
      selector = selector.to_sym
      if subject_is_any_instance?
        any_instance_better_expect(selector, options, &block)
      else
        subject.should respond_to selector
        mock_subject_method(selector, options, &block)
      end
    end

    def assert_negative_with(selector, options={}, &block)
      selector = selector.to_sym
      if subject_is_any_instance?
        any_instance_better_not_expect(selector, options, &block)
      else
        subject.should respond_to selector
        negative_mock_subject_method(selector, options, &block)
      end
    end


    private

    def subject_mock_proxy
      @mock_proxy ||= RSpec::Mocks.proxy_for(subject)
    end

    def mock_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      subject_mock_proxy.add_message_expectation(location, selector, options, &block)
    end

    def negative_mock_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      subject_mock_proxy.add_message_expectation(location, selector, options, &block).never
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
