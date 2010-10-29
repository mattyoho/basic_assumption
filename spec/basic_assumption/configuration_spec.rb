require 'spec_helper'

describe BasicAssumption::Configuration do
  it "provides a #configure class method that yields an instance of the class" do
    configuration_instance = nil
    BasicAssumption::Configuration.configure { |instance| configuration_instance = instance }
    configuration_instance.should be_a_kind_of(BasicAssumption::Configuration)
  end

  context "an instance" do
    class Assumer
      extend BasicAssumption
    end
    let(:config) { BasicAssumption::Configuration.new }
    let(:assuming_class) { named_class_extending Assumer }
    it "allows decent_exposure emulation mode" do
      config.emulate_exposure!
      assuming_class.should respond_to(:expose)
    end

    it "can set the default assumption" do
      config.default_assumption = Proc.new { :qux }
      assuming_class.class_eval do
        assume :baz
      end
      assuming_class.new.baz.should eql(:qux)
    end

    after(:all) do
      config.default_assumption = nil
    end
  end
end
