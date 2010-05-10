require 'spec_helper'
require 'active_support'

describe BasicAssumption::DefaultAssumption::Base do
  context "#block.call" do
    subject { BasicAssumption::DefaultAssumption::Base.new.block.call(:name) }
    it { should be_nil }
  end
end
