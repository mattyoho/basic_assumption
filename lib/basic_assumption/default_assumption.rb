require 'basic_assumption/default_assumption/base'
require 'basic_assumption/default_assumption/class_resolver'

module BasicAssumption
  module DefaultAssumption
    def self.register(klass, default)
      registry[klass.object_id] = strategy(default)
    end

    def self.resolve(klass)
      while !registry.has_key?(klass.object_id)
        klass = klass.superclass
        break if klass.nil?
      end
      registry[klass.object_id]
    end

    class << self
      attr_accessor :default

      protected
      def registry
        @registry ||= Hash.new { |h, k| strategy(default) }
      end

      def strategy(given=nil)
        case given
        when Proc
          given
        when Symbol
          ClassResolver.instance(given).block
        else
          Base.new.block
        end
      end
    end
  end
end
