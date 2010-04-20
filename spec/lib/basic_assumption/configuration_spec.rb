require 'spec_helper'

describe BasicAssumption::Configuration do
  it "provides a #configure class method that yields an instance of the class" do
    configuration_instance = nil
    BasicAssumption::Configuration.configure { |instance| configuration_instance = instance }
    configuration_instance.should be_a_kind_of(BasicAssumption::Configuration)
  end

  context "an instance" do
    class Exposer
      extend BasicAssumption
    end
    let(:instance) { BasicAssumption::Configuration.new }
    let(:exposing_class) { Exposer }
    it "allows decent_exposure emulation mode" do
      instance.emulate_exposure!
      exposing_class.should respond_to(:expose)
    end
  end
end
