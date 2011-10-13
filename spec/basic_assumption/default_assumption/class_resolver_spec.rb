require 'spec_helper'
require 'basic_assumption/default_assumption/class_resolver'

class BasicAssumption::DefaultAssumption::ExampleClass
  attr_reader :foo, :bar

  def initialize(foo=nil, bar=nil)
    @foo = foo; @bar = bar
  end
end

describe BasicAssumption::DefaultAssumption::ClassResolver do
  let(:resolver) { BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class) }

  context '#instance' do

    it 'returns a class instance from the BasicAssumption::DefaultAssumption namespace' do
      resolver.instance.should be_a_kind_of(BasicAssumption::DefaultAssumption::ExampleClass)
    end

    it 'raises an error if no such constant is found' do
      resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:name_error)
      expect { resolver.instance }.to raise_error(NameError)
    end
  end
end
