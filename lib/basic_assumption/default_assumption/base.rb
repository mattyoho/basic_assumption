module BasicAssumption
  module DefaultAssumption
    # Provides the default behavior out of the box for calls to
    # BasicAssumption#assume. +block+ is a method that returns a Proc instance.
    class Base
      # Returns a proc that accepts an argument (which is, in practice, the
      # name that was passed to BasicAssumption#assume) and returns +nil+.
      def block
        Proc.new { |name, context| }
      end
    end
  end
end

