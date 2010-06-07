require 'spec_helper'
require 'lib/basic_assumption/default_assumption/rails'

describe BasicAssumption::DefaultAssumption do
  let(:mod) { BasicAssumption::DefaultAssumption }
  describe "::register and ::resolve" do
    before do
      mod.should_receive(:strategy).with(:behavior).and_return(:block)
    end
    context "when a class is passed to resolve" do
      it "maps a class to a proc according to an internal strategy" do
        mod.register(Class, :behavior)
        mod.resolve(Class).should eql(:block)
      end
    end
    context "when a symbol is passed to resolve" do
      it "returns the strategy-determined proc for that symbol" do
        mod.resolve(:behavior).should eql(:block)
      end
    end
  end
  describe "::strategy" do
    it "returns the proc when given one" do
      a_proc = Proc.new { :block }
      mod.send(:strategy, a_proc).call.should eql(:block)
    end
    it "returns the block of a class in the BasicAssumption::DefaultAssumption namespace when given a symbol" do
      mod::Rails.should_receive(:new).and_return(stub(:block => :block))
      mod.send(:strategy, :rails).should eql(:block)
    end
    it "returns the block of a Base instance otherwise" do
      mod.send(:strategy, nil).call(:foo).should be_nil
    end
  end
  describe "::registry" do
    before(:each) do
      mod.send(:registry).clear
    end
    it "returns a default when given a key it doesn't have" do
      mod.default = :custom_default
      mod.stub!(:strategy).with(:custom_default).and_return(:some_block)
      mod.send(:registry).should_not have_key(:key)
      mod.send(:registry)[:key].should eql(:some_block)
    end
    after(:each) do
      mod.default = nil
    end
  end
end
