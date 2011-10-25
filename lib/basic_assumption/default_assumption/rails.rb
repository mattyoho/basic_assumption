require 'basic_assumption/default_assumption/action'
require 'basic_assumption/default_assumption/class_resolver'
require 'basic_assumption/default_assumption/name'
require 'basic_assumption/default_assumption/owner_builder'

module BasicAssumption
  module DefaultAssumption
    # Restful default behavior in the context of Rails
    class Rails
      attr_reader :action, :context, :name, :request #:nodoc:

      def initialize(name=nil, context={}, request=nil) #:nodoc:
        @context = context
        @name    = Name.new(context.delete(:as) || name)
        @request = request

        @action  = initialize_action
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
        default = self
        Proc.new do |name, context|
          context[:controller] = self

          default.class.new(name, context, request).result
        end
      end

      def result #:nodoc:
        action.outcome
      end

      protected

      def initialize_action
        name.plural? ? plural_action : singular_action
      end

      def singular_action
        Action.new(request) do |action|
          action.find do
            find_and_maybe_raise
          end
          action.update do
            record            = find_and_maybe_raise
            record.attributes = resource_attributes
            record
          end
          action.default do
            model_class.new(resource_attributes.merge(owner_attributes))
          end
        end
      end

      def plural_action
        Action.new(request) do |action|
          action.default do
            finder_scope
          end
        end
      end

      def finder_scope
        model_class.where(owner_attributes)
      end

      def model_class
        @model_class ||= ClassResolver.new(name).klass
      end

      def params
        @params ||= request ? request.params : {}
      end

      def find_and_maybe_raise
        begin
          finder_scope.find(params['id'])
        rescue
          raise if settings[:raise_error]
        end
      end

      def resource_attributes
        params[name.singular] || {}
      end

      def owner_attributes
        @owner_attributes ||= if context[:owner]
          OwnerBuilder.new(context[:owner], context[:controller]).attributes
        else
          {}
        end
      end

      def settings #:nodoc:
        @global_settings ||= BasicAssumption::Configuration.settings
        @global_settings.merge(context)
      end
    end
  end
end
