Feature: Rails Controllers Assume Find By Default

  Scenario: controller invokes assume without a block
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        assume :widget, :find_on_id => true
      end
      """
    And a file named "app/views/widgets/show.html.erb" with:
      """
      <blink><%= widget.name %></blink>
      """
    And a file named "features/widget_is_viewed_by_visitor.feature" with:
      """
      Feature: Widget is viewed by visitor
        Scenario: success
          Given a widget named "foobar"
          When I view the widget
          Then I should see "foobar"
      """
    When I run `bundle exec cucumber features/widget_is_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """

