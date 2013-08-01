module BetterReceive
  class Stub < Base

    def assert
      if selector.is_a?(Hash)
        selector.each do |single_selector, value|
          better_stub_method(single_selector.to_sym, options, &block).and_return(value)
        end
      else
        better_stub_method(selector, options, &block)
      end
      self
    end


    private

    def better_stub_method(selector, options, &block)
      selector = selector.to_sym
      if subject_is_any_instance?
        any_instance_better_expect(selector, options, &block)
      else
        subject.should respond_to selector
        @expectation = subject.stub(selector, options, &block)
      end
    end

    def expectation_chain(*args)
      RSpec::Mocks::AnyInstance::StubChain.new(*args)
    end
  end
end
