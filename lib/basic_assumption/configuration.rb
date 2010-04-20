module BasicAssumption
  class Configuration
    def self.configure
      yield self.new
    end

    def emulate_exposure!
      BasicAssumption.module_eval do
        alias expose assume
        alias default_exposure default_assumption
      end
    end
  end
end
