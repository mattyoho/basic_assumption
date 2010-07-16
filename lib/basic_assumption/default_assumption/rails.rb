module BasicAssumption
  module DefaultAssumption
    # Custom default behavior in the context of Rails.
    class Rails < BasicAssumption::DefaultAssumption::Base
      attr_reader :name, :params #:nodoc:

      def initialize(name=nil, params={}) #:nodoc:
        @name, @params = name.to_s, params
      end
      # Returns a block that will attempt to find an instance of
      # an ActiveRecord model based on the name that was given to
      # BasicAssumption#assume and an id value in the parameters.
      # The following two examples would be equivalent:
      #
      #   class WidgetController < ActionController::Base
      #     assume :widget
      #   end
      #
      #   class WidgetController < ActionController::Base
      #     assume(:widget) { Widget.find(params[:widget_id] || params[:id]) }
      #   end
      def block
        klass = self.class
        Proc.new do |name, context|
          klass.new(name, params).result
        end
      end

      def result #:nodoc:
        model_class.find(lookup_id)
      end

      protected
      def lookup_id #:nodoc:
        params["#{name}_id"] || params['id']
      end

      def model_class #:nodoc:
        @model_class ||= name.classify.constantize
      end
    end
  end
end
