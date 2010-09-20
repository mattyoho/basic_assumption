require 'bundler'
Bundler.setup
require 'basic_assumption'

module SubclassContainer
  def next_subclass_id
    @subclass_count ||= 0
    @subclass_count +=  1
  end
  extend self
end

Spec::Example::ExampleGroup.class_eval do
  def named_class_extending(base)
    extender = Class.new(base)
    subclass_name = "Subclass_#{SubclassContainer.next_subclass_id}_#{base.name.gsub(/:+/, '_')}"
    SubclassContainer.const_set subclass_name, extender
  end
end
