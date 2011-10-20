require 'spec_helper'
require 'active_support'
require 'basic_assumption/default_assumption/rails'

class Model
  attr_accessor :age, :color, :owner_id
  def initialize(hash = {})
    hash.each do |k, v|
      self.send("#{k}=", v)
    end
  end
end

describe BasicAssumption::DefaultAssumption::Rails do

  let(:default) { BasicAssumption::DefaultAssumption::Rails.new(:model, {}, request) }
  let(:request) { stub(:params => params, :get? => true) }
  let(:params)  { {'id' => 42} }

  context "#block" do
    let(:relation) { stub("where", :find => nil)  }

    before(:each) do
      Model.stub!(:where).and_return(relation)
    end

    it "attempts to find a model instance based off the given name" do
      relation.should_receive(:find).with(42).and_return(:model)
      BasicAssumption::DefaultAssumption::Rails.new(:model, {}, request).result.should eql(:model)
    end

    context "when passed an alternative model name" do
      it "finds a model instance based off the alternative name" do
        relation.should_receive(:find).with(42).and_return(:model)
        BasicAssumption::DefaultAssumption::Rails.new(:my_model, {:as => :model}, request).result.should eql(:model)
      end
    end

    context "when the name given to assume is plural" do
      let(:name) { :models }

      %w(create destroy edit index new show update).each do |action|
        let(:params) { {'action' => action} }

        context "when there is an id in the params" do
          before { params['id'] = 123 }
          context "when action is #{action}" do
            it "finds all the records of the model class" do
              Model.should_receive(:all)
              default.block.call(name, {})
            end
          end
        end

        context "when there is not an id in the params" do
          context "when action is #{action}" do
            it "finds all the records of the model class" do
              Model.should_receive(:all)
              default.block.call(name, {})
            end
          end
        end
      end

    end

    context "when the name given to assume is singular" do
      let(:name) { :model }
      context "in the index action" do
        let(:params)  { { 'action' => 'index' } }
        context "and there is an id in params" do
          before { params['id'] = 1 }
          it "attempts to find a model instance based off the given name" do
            relation.should_receive(:find).with(1).and_return(name)
            default.block.call(name, {}).should eql(name)
          end
        end
        context "and there is no id in params" do
          before { params['model'] = {:initializer => 'value'} }
          it "creates a new model instance and passes in appropriate params" do
            Model.should_receive(:new).with({:initializer => 'value'}).and_return(name)
            default.block.call(name, {}).should eql(name)
          end
        end
      end

      context "in the show action" do
        let(:params)  { { 'id' => 42, 'action' => 'show' } }

        it "attempts to find a model instance based off the given name" do
          relation.should_receive(:find).with(42).and_return(name)
          default.block.call(name, {}).should eql(:model)
        end
      end

      context "in the edit action" do
        let(:params)  { { 'id' => 42, 'action' => 'edit' } }

        it "attempts to find a model instance based off the given name" do
          relation.should_receive(:find).with(42).and_return(name)
          default.block.call(name, {}).should eql(:model)
        end
      end

      context "in the update action" do
        let(:params)  do
          { 'id' => 42 }
        end

        it "attempts to find a model instance based off the given name" do
          relation.should_receive(:find).with(42).and_return(name)
          default.block.call(name, {}).should eql(:model)
        end
      end

      context "in the destroy action" do
        let(:params)  { { 'id' => 42, 'action' => 'destroy' } }

        it "attempts to find a model instance based off the given name" do
          relation.should_receive(:find).with(42).and_return(name)
          default.block.call(name, {}).should eql(:model)
        end
      end

      context "in the create action" do
        let(:params) do
          {
            'action' => 'create',
            'model'  => { 'age' => 27, 'color' => 'blue' }
          }
        end

        context "the model instance" do
        subject { default.block.call(name, {}) }
          its(:age)   { should be(27) }
          its(:color) { should eql('blue') }
        end
      end

      context "in the new action" do
        let(:params) do
          {
            'action' => 'new',
            'model'  => { 'age' => 27, 'color' => 'blue' }
          }
        end

        context "the model instance" do
        subject { default.block.call(name, {}) }
          its(:age)   { should be(27) }
          its(:color) { should eql('blue') }
        end
      end
    end
  end

  context "ensuring ownership" do
    class User
      def id
        5678
      end
    end

    class Controller
      def owner
        User.new
      end
    end

    let(:params) { {'id' => 123} }

    it "accepts a symbol" do
      Model.should_receive(:where).with(:user_id => 5678).and_return(stub(:find => nil))

      default = BasicAssumption::DefaultAssumption::Rails.new(:model, {:owner => :owner, :controller => Controller.new}, request)

      default.result
    end

    it "accepts a proc" do
      Model.should_receive(:where).with(:user_id => 5678).and_return(stub(:find => nil))

      default = BasicAssumption::DefaultAssumption::Rails.new(:model, {:owner => proc { owner }, :controller => Controller.new}, request)

      default.result
    end

    context "with a specified column name" do

      it "obeys the column name" do
        Model.should_receive(:where).with(:user_id => 5678).and_return(stub(:find => nil))

        owner_context = {:column_name => :user_id, :object => proc { owner }}
        default = BasicAssumption::DefaultAssumption::Rails.new(:model, {:owner => owner_context, :controller => Controller.new}, request)

        default.result
      end

      it "obeys the column name given a proc" do
        Model.should_receive(:where).with(:owner_id => 5678).and_return(stub(:find => nil))

        owner_context = {:column_name => :owner_id, :object => :owner}
        default = BasicAssumption::DefaultAssumption::Rails.new(:model, {:owner => owner_context, :controller => Controller.new}, request)

        default.result
      end
    end
  end

  context "#make?" do
    subject { default.send(:make?) }
    before { default.stub(:list? => false, :lookup? => false) }
    context "when the action is not new or create" do
      context "when #list? is true" do
        before { default.stub(:list? => true) }
        context "when #lookup? is true" do
          before { default.stub(:lookup? => true) }
          it { should be_false }
        end
        context "when #lookup? is false" do
          it { should be_false }
        end
      end
      context "when #list? is false" do
        context "when #lookup? is true" do
          before { default.stub(:lookup? => true) }
          it { should be_false }
        end
        context "when #lookup? is false" do
          it { should be_true }
        end
      end
    end

    %w(new create).each do |action|
      context "when the action is #{action}" do
        before { default.stub(:action => action) }
        context "when #list? is true" do
          before { default.stub(:list? => true) }
          context "when #lookup? is true" do
            before { default.stub(:lookup? => true) }
            it { should be_true }
          end
          context "when #lookup? is false" do
            it { should be_true }
          end
        end
        context "when #list? is false" do
          context "when #lookup? is true" do
            before { default.stub(:lookup? => true) }
            it { should be_true }
          end
          context "when #lookup? is false" do
            it { should be_true }
          end
        end
      end
    end
  end
end
