module BasicAssumption
  module DefaultAssumption
    # Custom default behavior in the context of Rails.
    class SimpleRails < BasicAssumption::DefaultAssumption::Base
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
        Proc.new do |name|
          model_class = name.to_s.classify.constantize
          model_class.find(params["#{name}_id"] || params['id'])
        end
      end
    end
  end
end

