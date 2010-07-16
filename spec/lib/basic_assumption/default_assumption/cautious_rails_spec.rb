require 'spec_helper'
require 'active_support'
require 'basic_assumption/default_assumption/cautious_rails'

class Model; end

describe BasicAssumption::DefaultAssumption::CautiousRails do

  context "#block" do
    let(:default) { BasicAssumption::DefaultAssumption::CautiousRails.new }
    let(:params)  { stub(:[] => 42) }

    before(:each) do
      Model.stub!(:find)
      default.stub!(:params).and_return(params)
    end

    it "looks for a params[model_id] in its calling context" do
      params.should_receive(:[]).with('model_id').and_return(nil)
      default.block.call(:model, {})
    end

    it "does not look for params[id] in its calling context" do
      params.should_receive(:[]).with('id').never
      default.block.call(:model, {})
    end

    it "attempts to find a model instance based off the given name" do
      Model.should_receive(:find).with(42).and_return(:model)
      default.block.call(:model, {}).should eql(:model)
    end

    context "when passed an alternative model name" do
      it "finds a model instance based off the alternative name" do
        Model.should_receive(:find).with(42).and_return(:model)
        default.block.call(:my_model, {:as => :model}).should eql(:model)
      end
    end
  end
end
