if defined?(Rails) && Rails::VERSION::MAJOR == 3
  require 'basic_assumption/default_assumption/rails'

  module BasicAssumption
    class Railtie < Rails::Railtie

      initializer "basic_assumption.set_up_action_controller_base" do |app|
        ActionController::Base.class_eval do
          extend BasicAssumption

          def self.after_assumption(name)
            hide_action name
            helper_method name
          end
        end

        BasicAssumption::Configuration.configure do |config|
          config.default_assumption = :simple_rails
        end
      end
    end
  end
end
