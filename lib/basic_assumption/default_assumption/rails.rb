require 'basic_assumption/default_assumption/owner_builder'

module BasicAssumption
  module DefaultAssumption
    # Restful default behavior in the context of Rails
    class Rails
      attr_reader :action,  :context,
                  :params,  :name,
                  :request, :resource_attributes #:nodoc:

      def initialize(name=nil, context={}, request=nil) #:nodoc:
        @name                = name.to_s
        @context             = context
        @request             = request
        @params              = request ? request.params : {}
        @action              = params['action']
        @resource_attributes = params[singular_name] || {}
      end

      # Returns a block that will attempt to do the correct thing depending
      # on the plurality of the name passed to +assume+ and the action for the
      # current request. If the name is singular and the action is not 'new'
      # or 'create', then +assume+ will find an instance of
      # an ActiveRecord model of the name that it received and an id
      # value in the parameters. If the action is 'new' or 'create', +assume+
      # will instantiate a new instance of the model class, passing in the
      # values it finds in the +params+ hash with for a key of the name passed
      # to +assume+. For example:
      #
      #    class WidgetController < ApplicationController
      #      default_assumption :rails
      #      assume :widget
      #
      #      def create
      #        widget.save!    # widget is: Widget.new(params[:widget])
      #      end
      #    end
      #
      # Note the object will have been instantiated but not saved, destroyed,
      # etc.
      #
      # If the name passed to assume is plural, +assume+ returns all records
      # for the model.
      #
      # It is possible to specify an alternative model name:
      #
      #   class WidgetController < ApplicationController
      #     assume :sprocket, :as => :widget
      #   end
      #
      # This will create a +sprocket+ method in your actions and view
      # that will use the Widget model for its lookup.
      #
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
      #   conf.active_record.find_on_id  = true
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
          context[:controller] = self
          klass.new(name, context, request).result
        end
      end

      def result #:nodoc:
        return list if list?

        if make?
          model_class.new(resource_attributes.merge(owner_attributes))
        elsif lookup?
          lookup_and_maybe_raise
        end
      end

      protected

      def lookup_and_maybe_raise
        begin
          record            = model_class.where(owner_attributes).find(lookup_id)
          record.attributes = resource_attributes unless request.get?
          record
        rescue
          raise if settings[:raise_error]
        end
      end

      def owner_attributes
        @owner_attributes ||= if context[:owner]
          OwnerBuilder.new(context[:owner], context[:controller]).attributes
        else
          {}
        end
      end

      def list #:nodoc:
        model_class.all
      end

      def list? #:nodoc:
       plural_name.eql?(model_name)
      end

      def lookup_id #:nodoc:
        params['id']
      end

      def lookup? #:nodoc:
        lookup_id && !list?
      end

      def make? #:nodoc:
        %w(new create).include?(action) || !(lookup? || list?)
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
      def plural_name #:nodoc:
        model_name.pluralize
      end

      def singular_name #:nodoc:
        model_name.singularize
      end
    end
  end
end
