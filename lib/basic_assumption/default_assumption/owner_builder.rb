module BasicAssumption
  module DefaultAssumption
    class OwnerBuilder
      attr_reader :controller, :owner_context, :owner_method

      def initialize(owner_method_or_context, controller)
        @controller = controller

        if owner_method_or_context.kind_of? Hash
          @owner_method  = owner_method_or_context[:object]
          @owner_context = owner_method_or_context
        else
          @owner_method  = owner_method_or_context
          @owner_context = {}
        end
      end

      def attributes
        {column_name => owner_object.id}
      end

      def owner_object
        if owner_method.respond_to? :call
          controller.instance_eval(&owner_method)
        else
          controller.send(owner_method)
        end
      end

      def column_name
        owner_context[:column_name] || :"#{owner_object.class.name.downcase}_id"
      end
    end
  end
end

