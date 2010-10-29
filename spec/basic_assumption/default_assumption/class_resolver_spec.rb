require 'spec_helper'
require 'basic_assumption/default_assumption/class_resolver'

class ::ExampleClass
  attr_reader :foo, :bar
  def initialize(foo=nil, bar=nil)
    @foo = foo; @bar = bar
  end
end

describe BasicAssumption::DefaultAssumption::ClassResolver do
  let(:resolver) { BasicAssumption::DefaultAssumption::ClassResolver.new(nil) }
  context '#camelize, given a symbol or string' do
    it 'returns an upper camel-cased string' do
      resolver.camelize('camel').should eql('Camel')
    end
    it 'treats underscores as word boundaries and removes them' do
      resolver.camelize('camel_case_word').should eql('CamelCaseWord')
    end
  end
  context '#constantize' do
    it 'retrieves a constant from the BasicAssumption::DefaultAssumption namespace' do
      resolver.constantize('ClassResolver').should eql(BasicAssumption::DefaultAssumption::ClassResolver)
    end
    it 'raises an error if no such constant is found' do
      expect { resolver.constantize('CamelCase') }.to raise_error(NameError)
    end
  end
  context '#instance' do
    before(:each) do
      @resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class)
      @resolver.stub!(:constantize).and_return(ExampleClass)
    end
    it 'returns an instance of the resolved class' do
      @resolver.instance.should be_a_kind_of(ExampleClass)
    end
    it 'accepts and passes on any arguments to the instantiation of the object' do
      example_object = @resolver.instance('foo', 'bar')
      example_object.foo.should eql('foo')
      example_object.bar.should eql('bar')
    end
  end
  context '::instance' do
    it 'returns an instance of the resolved class' do
      mod = BasicAssumption::DefaultAssumption
      mod::ClassResolver.instance(:base).should be_an_instance_of(mod::Base)
    end
  end
end
