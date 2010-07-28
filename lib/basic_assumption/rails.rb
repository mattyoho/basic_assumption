if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'basic_assumption/default_assumption/cautious_rails'
  require 'basic_assumption/default_assumption/rails'
  require 'basic_assumption/default_assumption/restful_rails'

  module BasicAssumption
    # Must be required explicitly in Rails 3. Extends ActionController::Base
    # with BasicAssumption, sets the default assumption behavior to be the
    # :rails behavior, and sets up an +after_assumption+ hook.
    class Railtie < Rails::Railtie

      initializer "basic_assumption.set_up_action_controller_base" do |app|
        ActionController::Base.class_eval do
          extend BasicAssumption

          # Uses hide_action and helper_method to expose the method created
          # by +assume+ as a helper inside of views, and also disallows the
          # method from being called directly as a route endpoint.
          def self.after_assumption(name)
            hide_action name
            helper_method name
          end
        end

        BasicAssumption::Configuration.configure do |config|
          config.default_assumption = :rails
        end
      end
    end
  end
end
