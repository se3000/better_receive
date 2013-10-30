module BetterReceive
  class Mock < Base

    def assert
      if subject_is_any_instance?
        subject.instance_variable_set(:@expectation_set, true)
        any_instance_better_expect(selector, options, &block)
      else
        subject.should respond_to selector
        mock_subject_method(selector, options, &block)
      end
      self
    end

    def assert_negative
      if subject_is_any_instance?
        subject.instance_variable_set(:@expectation_set, true)
        any_instance_better_not_expect(selector, options, &block)
      else
        subject.should respond_to selector
        negative_mock_subject_method(selector, options, &block)
      end
      self
    end


    private

    def subject_mock_proxy
      @mock_proxy ||= RSpec::Mocks.proxy_for(subject)
    end

    def mock_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      @expectation = subject_mock_proxy.add_message_expectation(location, selector, options, &block)
    end

    def negative_mock_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      @expectation = subject_mock_proxy.add_message_expectation(location, selector, options, &block).never
    end

    def expectation_chain(*args)
      RSpec::Mocks::AnyInstance::PositiveExpectationChain.new(subject, *args)
    end
  end
end
