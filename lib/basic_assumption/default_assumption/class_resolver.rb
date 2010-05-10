module BasicAssumption
  module DefaultAssumption
    class ClassResolver
      def self.instance(name, *args)
        new(name).instance(*args)
      end
      def initialize(name)
        @name = name
      end
      def instance(*args)
        constantize(camelize(@name)).new(*args)
      end
      def camelize(name)
        name.to_s.gsub(/(?:^|_)(.)/) { "#{$1.upcase}" }
      end
      def constantize(name)
        namespace = BasicAssumption::DefaultAssumption
        namespace.const_missing(name) unless namespace.const_defined? name
        namespace.const_get(name)
      end
    end
  end
end
