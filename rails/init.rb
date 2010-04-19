begin
  require File.join(File.dirname(__FILE__), 'lib', 'basic_assumption')
rescue LoadError
  require 'basic_assumption'
end

ActionController::Base.class_eval do
  extend BasicAssumption

  def self.after_assumption(name)
    hide_action name
    helper_method name
  end
end
