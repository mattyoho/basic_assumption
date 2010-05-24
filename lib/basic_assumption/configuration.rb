module BasicAssumption
  # Provides app-level configuration options for +BasicAssumption+.
  # Useful in a Rails initializer or something similar.
  class Configuration
    # === Example
    #   BasicAssumption::Configuration.configure do |conf|
    #     conf.default_assumption = Proc.new { "I <3 GitHub." }
    #   end
    def self.configure #:yields: config_instance
      yield self.new
    end

    # Invoke this method if you want to have API compatibility
    # with the DecentExposure library.
    # (http://www.github.com/voxdolo/decent_exposure)
    # Namely, this provides +expose+ and +default_exposure+ which work
    # identically to +assume+ and +default_assumption+ (or rather, vice-versa.)
    def emulate_exposure!
      BasicAssumption.module_eval do
        alias expose assume
        alias default_exposure default_assumption
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
