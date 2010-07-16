require 'basic_assumption/default_assumption/rails'

module BasicAssumption
  module DefaultAssumption
    # Custom default behavior in the context of Rails.
    class CautiousRails < BasicAssumption::DefaultAssumption::Rails
      # Returns a block that will attempt to find an instance of
      # an ActiveRecord model based on the name that was given to
      # BasicAssumption#assume and an id value in the parameters.
      # It will not find based on params[:id], only params[:model_id].
      # The following two examples would be equivalent:
      #
      #   class WidgetController < ActionController::Base
      #     assume :widget
      #   end
      #
      #   class WidgetController < ActionController::Base
      #     assume(:widget) { Widget.find(params[:widget_id]) }
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
        super
      end

      protected
      def lookup_id #:nodoc:
        params["#{name}_id"]
      end
    end
  end
end

