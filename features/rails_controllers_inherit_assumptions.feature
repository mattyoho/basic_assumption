Feature: Rails Controllers Inherit Assumptions

  Scenario: controller inherits assumption
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        assume(:widget) { Widget.find(params[:id]) }
      end
      """
    And a file named "app/controllers/derived_widgets_controller.rb" with:
      """
      class DerivedWidgetsController < WidgetsController
        assume(:widget) { Widget.find(params[:id]) }
      end
      """
    And a file named "app/views/derived_widgets/show.html.erb" with:
      """
      <scroll><%= widget.name %></scroll>
      """
    And a file named "features/derived_widget_is_viewed_by_visitor.feature" with:
      """
      Feature: Widget is viewed by visitor
        Scenario: success
          Given a derived widget named "foobar"
          When I view the derived widget
          Then I should see "foobar"
      """
    When I run `cucumber features/derived_widget_is_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """

