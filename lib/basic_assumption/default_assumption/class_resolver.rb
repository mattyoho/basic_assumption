require 'active_support/inflector'

module BasicAssumption
  module DefaultAssumption
    class ClassResolver #:nodoc:
      include ActiveSupport::Inflector

      attr_reader :name, :namespace

      def initialize(name, namespace='')
        @name, @namespace = name, namespace
      end

      def klass
        @klass ||= constantize(class_name_in_namespace)
      end

      def instance
        klass.new
      end

      private

      def class_name_in_namespace
        "#{namespace}::#{camelize(name)}"
      end
    end
  end
end
