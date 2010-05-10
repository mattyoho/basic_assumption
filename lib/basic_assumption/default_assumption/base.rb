module BasicAssumption
  module DefaultAssumption
    class Base
      def block
        Proc.new { |name| }
      end
    end
  end
end

