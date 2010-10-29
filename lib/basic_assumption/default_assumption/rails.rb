module BasicAssumption
  module DefaultAssumption
    # Custom default behavior in the context of Rails.
    class Rails < BasicAssumption::DefaultAssumption::Base
      attr_reader :name, :context, :params #:nodoc:

      def initialize(name=nil, context={}, params={}) #:nodoc:
        @name, @context, @params = name.to_s, context, params
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
      #
      # It is possible to specify an alternative model name:
      #
      #   class WidgetController < ApplicationController
      #     assume :sprocket, :as => :widget
      #   end
      #
      # This will create a +sprocket+ method in your actions and view
      # that will use the Widget model for its lookup.
      def block
        klass = self.class
        Proc.new do |name, context|
          klass.new(name, context, params).result
        end
      end

      def result #:nodoc:
        model_class.find(lookup_id)
      end

      protected
      def lookup_id #:nodoc:
        if context[:find_on_id]
          params["#{name}_id"] || params['id']
        else
          params["#{name}_id"]
        end
      end

      def model_class #:nodoc:
        @model_class ||= model_name.classify.constantize
      end

      def model_name #:nodoc:
        context[:as] ? context[:as].to_s : name
      end
    end
  end
end
