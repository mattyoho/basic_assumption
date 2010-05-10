require 'spec_helper'
require 'active_support'
require 'basic_assumption/default_assumption/simple_rails'

describe BasicAssumption::DefaultAssumption::SimpleRails do
  class Model; end

  context "#block" do
    let(:default) { BasicAssumption::DefaultAssumption::SimpleRails.new }
    let(:params)  { stub(:[] => 42) }

    before(:each) do
      Model.stub!(:find)
      default.stub!(:params).and_return(params)
    end

    it "looks for a params[model_id] and params[id] in its calling context" do
      params.should_receive(:[]).with('model_id').and_return(nil)
      params.should_receive(:[]).with('id')
      default.block.call(:model)
    end

    it "attempts to find a model instance based off the given name" do
      Model.should_receive(:find).with(42).and_return(:model)
      default.block.call(:model).should eql(:model)
    end
  end
end
