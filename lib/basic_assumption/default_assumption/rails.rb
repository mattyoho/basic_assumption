module BasicAssumption
  module DefaultAssumption
    # Custom default behavior in the context of Rails.
    class Rails < BasicAssumption::DefaultAssumption::Base
      attr_reader :name, :context, :params, :request #:nodoc:

      def initialize(name=nil, context={}, request=nil) #:nodoc:
        @name    = name.to_s
        @context = context
        @request = request
        @params  = request.params if request
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
      #     assume(:widget) { Widget.find(params[:widget_id]) rescue nil }
      #   end
      #
      # The find can also fall back to using params[:id] when
      # :find_on_id is specified. The following are equivalent:
      #
      #   class WidgetController < ActionController::Base
      #     assume :widget, :find_on_id => true
      #   end
      #
      #   class WidgetController < ActionController::Base
      #     assume(:widget) { Widget.find(params[:widget_id] || params[:id]) rescue nil }
      #   end
      #
      # The find will, by default, swallow errors encountered
      # when finding. This can be overridden by setting :raise_error.
      #
      #   class WidgetController < ActionController::Base
      #     assume :widget, :raise_error => true
      #   end
      #
      #   class WidgetController < ActionController::Base
      #     assume(:widget) { Widget.find(params[:widget_id]) }
      #   end
      #
      # Both of these settings can be turned on by default via
      # configuration options, such as:
      #
      #   conf.active_record.raise_error = true
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
          klass.new(name, context, request).result
        end
      end

      def result #:nodoc:
        begin
          model_class.find(lookup_id)
        rescue
          raise if settings[:raise_error]
          nil
        end
      end

      protected
      def lookup_id #:nodoc:
        if settings[:find_on_id]
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

      def settings #:nodoc:
        @global_settings ||= BasicAssumption::Configuration.settings
        @global_settings.merge(context)
      end
    end
  end
end
