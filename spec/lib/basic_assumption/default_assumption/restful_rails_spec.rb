require 'spec_helper'
require 'active_support'
require 'basic_assumption/default_assumption/restful_rails'

describe BasicAssumption::DefaultAssumption::RestfulRails do
  class Model
    attr_accessor :age, :color
    def initialize(hash = {})
      hash.each do |k, v|
        self.send("#{k}=", v)
      end
    end
  end

  context "#block" do
    let(:default) { BasicAssumption::DefaultAssumption::RestfulRails.new(:model, params) }

    before(:each) do
      Model.stub!(:find)
      default.stub!(:params).and_return(params)
    end

    context "when the name given to assume is plural" do
      let(:name) { :models }

      context "without pagination" do
        %w(create destroy edit index new show update).each do |action|
          let(:params) { {'action' => action} }

          context "when there is an id in the params" do
            before { params['id'] = 123 }
            context "when action is #{action}" do
              before { Model.should_receive(:all) }
              context "when 'page' exists in the request params" do
                before { params['page'] = '5' }
                it "finds all the records of the model class" do
                  default.block.call(name)
                end
              end
              context "when 'page' does not exist in the request params" do
                it "finds all the records of the model class" do
                  default.block.call(name)
                end
              end
            end
          end

          context "when there is not an id in the params" do
            context "when action is #{action}" do
              before { Model.should_receive(:all) }
              context "when 'page' exists in the request params" do
                before { params['page'] = '5' }
                it "finds all the records of the model class" do
                  default.block.call(name)
                end
              end
              context "when 'page' does not exist in the request params" do
                it "finds all the records of the model class" do
                  default.block.call(name)
                end
              end
            end
          end
        end
      end

      %w(create destroy edit index new show update).each do |action|
        let(:params) { {'action' => action} }

        context "with pagination" do
          context "when there is an id in the params" do
            before { params['id'] = 123 }
            context "when action is #{action}" do
              before { Model.stub! :paginate }
              context "when 'page' exists in the request params" do
                before { params['page'] = '5' }
                it "paginates the records of the model class" do
                  Model.should_receive(:paginate)
                  default.block.call(name)
                end
                context "when 'per_page' exists in the request params" do
                  it "paginates using 'page' and 'per_page' from the params" do
                    params['per_page'] = '10'
                    Model.should_receive(:paginate).with('page' => '5', 'per_page' => '10')
                    default.block.call(name)
                  end
                end
                context "when 'per_page' does not exist in the request params" do
                  it "paginates using 'page' from the params and a default 'per_page' of 15" do
                    Model.should_receive(:paginate).with('page' => '5', 'per_page' => '15')
                    default.block.call(name)
                  end
                end
              end
              context "when 'page' does not exist in the request params" do
                it "finds all the records of the model class" do
                  Model.should_receive(:all)
                  default.block.call(name)
                end
              end
            end
          end

          context "when there is not an id in the params" do
            context "when action is #{action}" do
              before { Model.stub! :paginate }
              context "when 'page' exists in the request params" do
                before { params['page'] = '5' }
                it "paginates the records of the model class" do
                  Model.should_receive(:paginate)
                  default.block.call(name)
                end
                context "when 'per_page' exists in the request params" do
                  it "paginates using 'page' and 'per_page' from the params" do
                    params['per_page'] = '10'
                    Model.should_receive(:paginate).with('page' => '5', 'per_page' => '10')
                    default.block.call(name)
                  end
                end
                context "when 'per_page' does not exist in the request params" do
                  it "paginates using 'page' from the params and a default 'per_page' of 15" do
                    Model.should_receive(:paginate).with('page' => '5', 'per_page' => '15')
                    default.block.call(name)
                  end
                end
              end
              context "when 'page' does not exist in the request params" do
                it "finds all the records of the model class" do
                  Model.should_receive(:all)
                  default.block.call(name)
                end
              end
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
            Model.should_receive(:find).with(1).and_return(name)
            default.block.call(name).should eql(name)
          end
        end
        context "and there is no id in params" do
          before { params['model'] = :initializers }
          it "creates a new model instance and passes in appropriate params" do
            Model.should_receive(:new).with(:initializers).and_return(name)
            default.block.call(name).should eql(name)
          end
        end
      end

      context "in the show action" do
        let(:params)  { { 'id' => 42, 'action' => 'show' } }

        it "attempts to find a model instance based off the given name" do
          Model.should_receive(:find).with(42).and_return(name)
          default.block.call(name).should eql(:model)
        end
      end

      context "in the edit action" do
        let(:params)  { { 'id' => 42, 'action' => 'edit' } }

        it "attempts to find a model instance based off the given name" do
          Model.should_receive(:find).with(42).and_return(name)
          default.block.call(name).should eql(:model)
        end
      end

      context "in the update action" do
        let(:params)  do
          { 'id' => 42 }
        end

        it "attempts to find a model instance based off the given name" do
          Model.should_receive(:find).with(42).and_return(name)
          default.block.call(name).should eql(:model)
        end
      end

      context "in the destroy action" do
        let(:params)  { { 'id' => 42, 'action' => 'destroy' } }

        it "attempts to find a model instance based off the given name" do
          Model.should_receive(:find).with(42).and_return(name)
          default.block.call(name).should eql(:model)
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
        subject { default.block.call(name) }
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
        subject { default.block.call(name) }
          its(:age)   { should be(27) }
          its(:color) { should eql('blue') }
        end
      end
    end
  end

  context "#make?" do
    let(:rr) { BasicAssumption::DefaultAssumption::RestfulRails.new }
    subject { rr.send(:make?) }
    before { rr.stub(:list? => false, :lookup? => false) }
    context "when the action is not new or create" do
      context "when #list? is true" do
        before { rr.stub(:list? => true) }
        context "when #lookup? is true" do
          before { rr.stub(:lookup? => true) }
          it { should be_false }
        end
        context "when #lookup? is false" do
          it { should be_false }
        end
      end
      context "when #list? is false" do
        context "when #lookup? is true" do
          before { rr.stub(:lookup? => true) }
          it { should be_false }
        end
        context "when #lookup? is false" do
          it { should be_true }
        end
      end
    end
    %w(new create).each do |action|
      context "when the action is #{action}" do
        before { rr.stub(:action => action) }
        context "when #list? is true" do
          before { rr.stub(:list? => true) }
          context "when #lookup? is true" do
            before { rr.stub(:lookup? => true) }
            it { should be_true }
          end
          context "when #lookup? is false" do
            it { should be_true }
          end
        end
        context "when #list? is false" do
          context "when #lookup? is true" do
            before { rr.stub(:lookup? => true) }
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
