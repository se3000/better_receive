module BetterReceive
  class Stub < Base

    def assert_with(selector, options={}, &block)
      if subject_is_any_instance?
        any_instance_better_expect(selector, options, &block)
      else
        subject.should respond_to selector
        stub_subject_method(selector, options, &block)
      end
    end


    private

    def stub_subject_method(selector, options, &block)
      location = options[:expected_from] || caller(1)[2]
      subject_mock_proxy.add_stub(location, selector, options, &block)
    end

    def expectation_chain(*args)
      RSpec::Mocks::AnyInstance::StubChain.new(*args)
    end

  end
end
