require 'basic_assumption/default_assumption/rails'

module BasicAssumption
  module DefaultAssumption
    # Restful default behavior in the context of Rails
    class RestfulRails < BasicAssumption::DefaultAssumption::Rails
      attr_reader :action,
                  :page,
                  :per_page,
                  :resource_attributes #:nodoc:

      def initialize(name = nil, context={}, params = {}) #:nodoc:
        super
        @action    = params['action']
        @resource_attributes = params[singular_name]

        if @page = params[:page]
          @per_page = params[:per_page]
        end
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
      # If the name passed to assume is plural, there are two possibilities
      # for the # behavior of +assume+. If the model responds to +paginate+ and
      # there is a +page+ key in the +params+ hash, +assume+ will attempt to
      # find all records of the model type paginated based on the +page+
      # value in params and also a +per_page+ value. Otherwise, it returns all
      # # records for the model.
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
          model_class.find(lookup_id)
        end
      end

      protected

      def list #:nodoc:
        if page?
          model_class.paginate(:page => page, :per_page => per_page)
        else
          model_class.all
        end
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

      def page? #:nodoc:
        page.present? && model_class.respond_to?(:paginate)
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
