Feature: Rails Show Action Is Correct

  Scenario: restful show
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :rails
        assume :widget
      end
      """
    And a file named "app/views/widgets/show.html.erb" with:
      """
      <span><%= widget.name %></span>
      """
    And a file named "features/widget_is_viewed_by_visitor.feature" with:
      """
      Feature: All widgets are viewed by visitor
        Scenario: success
          Given a widget named "sprocket"
          When I view the widget
          Then I should see "sprocket"
      """
    When I run `cucumber features/widget_is_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """
