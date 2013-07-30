module BetterReceive
  class Stub < Base

    def assert_with(selector_or_hash, options={}, &block)
      if selector_or_hash.is_a?(Hash)
        selector_or_hash.each do |selector, value|
          better_stub_method(selector, options, &block).and_return(value)
        end
      else
        better_stub_method(selector_or_hash, options, &block)
      end
    end


    private

    def better_stub_method(selector, options, &block)
      selector = selector.to_sym
      if subject_is_any_instance?
        any_instance_better_expect(selector, options, &block)
      else
        subject.should respond_to selector
        subject.stub(selector, options, &block)
      end
    end

    def expectation_chain(*args)
      RSpec::Mocks::AnyInstance::StubChain.new(*args)
    end
  end
end
