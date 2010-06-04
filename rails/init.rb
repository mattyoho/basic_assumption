require 'basic_assumption'
require 'basic_assumption/default_assumption/rails'

ActionController::Base.class_eval do
  extend BasicAssumption

  def self.after_assumption(name)
    hide_action name
    helper_method name
  end
end

BasicAssumption::Configuration.configure do |config|
  config.default_assumption = :rails
end
