require 'spec_helper'
require 'basic_assumption/default_assumption/class_resolver'

class BasicAssumption::DefaultAssumption::ExampleClass
  attr_reader :foo, :bar

  def initialize(foo=nil, bar=nil)
    @foo = foo; @bar = bar
  end
end

module Foo
  class ExampleClass
  end
end

class TopLevelExampleClass
end

describe BasicAssumption::DefaultAssumption::ClassResolver do

  context '#klass' do
    it 'returns a class from the BasicAssumption::DefaultAssumption namespace' do
      resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class, 'BasicAssumption::DefaultAssumption')
      resolver.klass.should equal(BasicAssumption::DefaultAssumption::ExampleClass)
    end

    context "specifying a namespace" do
      it 'returns a class from that namespace' do
        resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class, 'Foo')
        resolver.klass.should equal(Foo::ExampleClass)
      end

      it 'returns a class from the top-level namespace by default' do
        resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:top_level_example_class)
        resolver.klass.should equal(TopLevelExampleClass)
      end
    end
  end

  context '#instance' do

    it 'returns a class instance from the BasicAssumption::DefaultAssumption namespace' do
      resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class, 'BasicAssumption::DefaultAssumption')
      resolver.instance.should be_a_kind_of(BasicAssumption::DefaultAssumption::ExampleClass)
    end

    it 'raises an error if no such constant is found' do
      resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:no_such_class)
      expect { resolver.instance }.to raise_error(NameError)
    end

    context "specifying a namespace" do
      it 'returns a class instance from that namespace' do
        resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:example_class, 'Foo')
        resolver.instance.should be_a_kind_of(Foo::ExampleClass)
      end

      it 'returns a class instance from the top-level namespace' do
        resolver = BasicAssumption::DefaultAssumption::ClassResolver.new(:top_level_example_class)
        resolver.instance.should be_a_kind_of(TopLevelExampleClass)
      end
    end
  end
end
