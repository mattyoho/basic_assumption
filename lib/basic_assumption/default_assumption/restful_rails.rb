module BasicAssumption
  module DefaultAssumption
    class RestfulRails < BasicAssumption::DefaultAssumption::Base
      attr_reader :action,
                  :lookup_id,
                  :name,
                  :page,
                  :per_page,
                  :resource_attributes

      def initialize(name, params)
        @action    = params['action']
        @lookup_id = params['id']
        @name      = name.to_s
        @resource_attributes = params[singular_name]

        if @page = params['page']
          @per_page = params['per_page'] || '15'
        end
      end

      def block
        klass = self.class
        Proc.new do |name|
          klass.new(name, params).result
        end
      end

      def result
        if list?
          list
        elsif make?
          model_class.new(resource_attributes)
        else
          model_class.find(lookup_id)
        end
      end

      protected

      def find?
        %w(show edit update destroy).include? action
      end

      def list
        if page?
          model_class.paginate('page' => page, 'per_page' => per_page)
        else
          model_class.all
        end
      end

      def list?
        action.eql?('index') && plural_name.eql?(name)
      end

      def make?
        %w(new create).include? action
      end

      def model_class
        @model_class ||= name.classify.constantize
      end

      def page?
        page.present? && model_class.respond_to?(:paginate)
      end

      def plural_name
        name.pluralize
      end

      def singular_name
        name.singularize
      end
    end
  end
end
