require 'spec_helper'

class FakeController
  def fake_params
    {:foo => :bar}
  end
  def self.hide_action(name)
  end
  def self.helper_method(name)
  end
end

describe BasicAssumption do

  context "a controller extends BasicAssumption" do

    let(:controller_class) { Class.new(FakeController) }
    let(:controller_instance) { controller_class.new }
    before(:each) do
      controller_class.extend(BasicAssumption)
    end

    it "declares named resources via 'assume'" do
      expect {
        controller_class.class_eval do
          assume :resource_name
        end
      }.to_not raise_error(NoMethodError)
    end

    it "declares an instance method of the given name" do
      controller_class.class_eval do
        assume :my_method_name
      end
      controller_instance.should respond_to(:my_method_name)
    end

    it "invokes a given block as the method implementation" do
      controller_class.class_eval do
        assume(:resource) { 'this is my resource' }
      end
      controller_instance.resource.should eql('this is my resource')
    end

    it "memoizes the result of the block for further method calls" do
      controller_class.class_eval do
        assume(:random_once) { "#{rand(1_000_000)} #{rand(1_000_000)}" }
      end
      controller_instance.random_once.should eql(controller_instance.random_once)
    end

    it "invokes the block in the context of the extending instance" do
      controller_class.class_eval do
        assume(:access_instance) { fake_params }
      end
      controller_instance.access_instance.should eql({:foo => :bar})
    end

    it "hides the method from being an action" do
      controller_class.should_receive(:hide_action).with(:resource_name)
      controller_class.class_eval do
        assume(:resource_name)
      end
    end

    it "makes the method visible in views" do
      controller_class.should_receive(:helper_method).with(:resource_name)
      controller_class.class_eval do
        assume(:resource_name)
      end
    end
  end

end
