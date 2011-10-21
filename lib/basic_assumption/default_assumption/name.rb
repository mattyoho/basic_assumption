require 'active_support/inflector'

module BasicAssumption
  module DefaultAssumption
    class Name
      include ActiveSupport::Inflector

      attr_reader :name

      def initialize(name)
        @name = name.to_s
      end

      def singular
        singularize(name)
      end

      def plural
        pluralize(name)
      end

      def plural?
        plural.eql?(name)
      end

      def to_s
        singular
      end

    end
  end
end
