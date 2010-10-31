require 'basic_assumption/configuration/active_record'

module BasicAssumption
  # Provides app-level configuration options for +BasicAssumption+.
  # Useful in a Rails initializer or something similar.
  class Configuration
    # === Example
    #   BasicAssumption::Configuration.configure do |conf|
    #     conf.default_assumption = Proc.new { "I <3 GitHub." }
    #   end
    def self.configure #:yields: config_instance
      @configuration = self.new
      yield @configuration
    end

    def self.settings
      @configuration.active_record.settings_hash
    end

    attr_reader :active_record #:nodoc:

    def initialize #:nodoc:
      @active_record = self.class::ActiveRecord.new
    end

    # Allows substituting another method name aside from +assume+
    def alias_assume_to(*aliases)
      aliases.each do |a|
        BasicAssumption.module_eval "alias #{a} assume"
      end
    end

    # Allows setting the default behavior for +assume+ calls in your app. Note
    # this is an assignment, which differs from the +default_assumption+ calls
    # inside of classes that extend +BasicAssumption+.
    def default_assumption=(value)
      BasicAssumption::DefaultAssumption.default = value
    end
  end
end
