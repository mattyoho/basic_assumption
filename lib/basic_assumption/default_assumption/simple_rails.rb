module BasicAssumption
  module DefaultAssumption
    class SimpleRails < BasicAssumption::DefaultAssumption::Base
      def block
        Proc.new do |name|
          model_class = name.to_s.classify.constantize
          model_class.find(params["#{name}_id"] || params['id'])
        end
      end
    end
  end
end

