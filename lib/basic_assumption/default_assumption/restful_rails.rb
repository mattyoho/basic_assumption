module BasicAssumption
  module DefaultAssumption
    # Restful default behavior in the context of Rails
    class RestfulRails < BasicAssumption::DefaultAssumption::Base
      attr_reader :action,
                  :lookup_id,
                  :name,
                  :page,
                  :per_page,
                  :resource_attributes #:nodoc:

      def initialize(name = nil, params = {}) #:nodoc:
        @action    = params['action']
        @lookup_id = params['id']
        @name      = name.to_s
        @resource_attributes = params[singular_name]

        if @page = params['page']
          @per_page = params['per_page'] || '15'
        end
      end

      # Returns a block that will attempt to do the correct thing depending
      # on which action the request is triggering. If the action is 'show',
      # 'edit', 'update', or 'destroy', then +assume+ will find an instance of
      # an ActiveRecord model based on the +name+ that it recieved and an id
      # value in the parameters. If the action is 'new' or 'create', +assume+
      # will instantiate a new instance of the model class, passing in the
      # values it finds in the +params+ hash with a key of the singularized
      # form of the +name+ passed to +assume+. For example:
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
      # etc. If the action is 'index', there are two possibilities for the
      # behavior of +assume+. If the +name+ passed is of singular form, then
      # a find will be performed, just as for a show or edit action. If the
      # +name+ is a plural word, then +assume+ will find all instances of
      # the model class.
      #
      # However, if the model responds to +paginate+ and there is a +page+
      # key in the +params+ hash, +assume+ will attempt to paginate the
      # results, also observing a +per_page+ value in the +params+ hash or
      # defaulting to 15 if one is not found.
      def block
        klass = self.class
        Proc.new do |name|
          klass.new(name, params).result
        end
      end

      def result #:nodoc:
        if list?
          list
        elsif make?
          model_class.new(resource_attributes)
        else
          model_class.find(lookup_id)
        end
      end

      protected

      def find? #:nodoc:
        %w(show edit update destroy).include? action
      end

      def list #:nodoc:
        if page?
          model_class.paginate('page' => page, 'per_page' => per_page)
        else
          model_class.all
        end
      end

      def list? #:nodoc:
        action.eql?('index') && plural_name.eql?(name)
      end

      def make? #:nodoc:
        %w(new create).include? action
      end

      def model_class #:nodoc:
        @model_class ||= name.classify.constantize
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
