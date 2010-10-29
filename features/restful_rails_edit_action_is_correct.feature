Feature: Restful Rails Edit Action Is Correct

  Scenario: restful edit
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widget
      end
      """
    And a file named "app/views/widgets/edit.html.erb" with:
      """
      <h2>Editing <%= widget.name %></h2>
      """
    And a file named "features/widget_is_edited_by_visitor.feature" with:
      """
      Feature: Widget is edited by visitor
        Scenario: success
          Given a widget named "sprocket"
          When I edit the widget
          Then I should see "Editing sprocket"
      """
    When I run "cucumber features/widget_is_edited_by_visitor.feature"
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """
