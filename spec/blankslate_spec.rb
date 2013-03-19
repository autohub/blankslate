require 'spec_helper'

describe BlankSlate do
  let(:blank_slate) { BlankSlate.new }

  def call(obj, meth, *args)
    BlankSlate.find_hidden_method(meth).bind(obj).call(*args)
  end

  def rspec_stubs
    ['as_null_object', 'null_object?', 'received_message?', 'rspec_reset', 'rspec_verify', 'should', 'should_not', 'should_not_receive', 'should_receive', 'stub', 'stub!', 'stub_chain', 'unstub', 'unstub!']
  end

  describe 'cleanliness' do
    it 'should not have many methods' do
      BlankSlate.instance_methods.
        map(&:to_s).-(rspec_stubs).sort.
        should == ['__id__', '__send__', 'instance_eval']
    end
  end

  context 'when methods are added to Object' do
    after :each  do
      class Object
        undef :foo
      end
    end

    it 'should still be blank' do
      class Object
        def foo
        end
      end
      Object.new.foo

      lambda {
        BlankSlate.new.foo
      }.should raise_error(NoMethodError)
    end
  end
end
