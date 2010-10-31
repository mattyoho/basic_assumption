require 'spec_helper'

describe BasicAssumption::Configuration do
  it "provides a #configure class method that yields an instance of the class" do
    configuration_instance = nil
    BasicAssumption::Configuration.configure { |instance| configuration_instance = instance }
    configuration_instance.should be_a_kind_of(BasicAssumption::Configuration)
  end

  describe ".settings" do
    it "returns a hash of the current settings" do
      BasicAssumption::Configuration.configure do |config|
        config.active_record.raise_error = true
      end

      settings = BasicAssumption::Configuration.settings
      settings.should have_key(:raise_error)
      settings[:raise_error].should be_true
    end
  end

  context "an instance" do
    class Assumer
      extend BasicAssumption
    end
    let(:config) { BasicAssumption::Configuration.new }
    let(:assuming_class) { named_class_extending Assumer }

    describe "#alias_assume_to" do
      it "aliases the #assume method" do
        config.alias_assume_to :expose, :provide
        assuming_class.should respond_to(:expose)
        assuming_class.should respond_to(:provide)
      end
    end

    it "can set the default assumption" do
      config.default_assumption = Proc.new { :qux }
      assuming_class.class_eval do
        assume :baz
      end
      assuming_class.new.baz.should eql(:qux)
    end

    context "active_record" do
      it "has a raise_error setting" do
        expect do
          config.active_record.raise_error = true
        end.to_not raise_error
      end

      it "has a find_on_id setting" do
        expect do
          config.active_record.find_on_id = true
        end.to_not raise_error
      end
    end

    after(:all) do
      config.default_assumption = nil
    end
  end
end
