require 'basic_assumption/default_assumption/rails'

module BasicAssumption
  module DefaultAssumption
    # Restful default behavior in the context of Rails
    class RestfulRails < BasicAssumption::DefaultAssumption::Rails
      attr_reader :action,
                  :resource_attributes #:nodoc:

      def initialize(name=nil, context={}, request=nil) #:nodoc:
        super
        @params            ||= {}
        @action              = params['action']
        @resource_attributes = params[singular_name]
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
      #      default_assumption :restful_rails
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
      def block
        super
      end

      def result #:nodoc:
        if list?
          list
        elsif make?
          model_class.new(resource_attributes)
        elsif lookup?
          begin
            if owner_method = context[:owner]
              owner = context[:controller].send(owner_method)
              conditions = {owner.class.name.downcase + '_id' => owner.id}
              model_class.where(conditions).find(lookup_id)
            else
              model_class.find(lookup_id)
            end
          rescue
            raise if settings[:raise_error]
            nil
          end
        end
      end

      protected

      def list #:nodoc:
        model_class.all
      end

      def list? #:nodoc:
       plural_name.eql?(name)
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

      def plural_name #:nodoc:
        name.pluralize
      end

      def singular_name #:nodoc:
        name.singularize
      end
    end
  end
end
