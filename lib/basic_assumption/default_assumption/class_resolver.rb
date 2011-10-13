require 'active_support/inflector'

module BasicAssumption
  module DefaultAssumption
    class ClassResolver #:nodoc:
      include ActiveSupport::Inflector

      def initialize(name)
        @name = name
      end

      def instance
        constantize(class_name_in_namespace).new
      end

      private

      def class_name_in_namespace
        "BasicAssumption::DefaultAssumption::#{camelize(@name)}"
      end
    end
  end
end
