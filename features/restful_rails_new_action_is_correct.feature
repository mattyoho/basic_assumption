Feature: Restful Rails New Action Is Correct

  Scenario: restful new
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widget
      end
      """
    And a file named "app/views/widgets/new.html.erb" with:
      """
      <% if widget.new_record? %>
        Widget is new
      <% end %>
      """
    And a file named "features/widget_is_newed_by_visitor.feature" with:
      """
      Feature: Widget is newed by visitor
        Scenario: success
          When I go to the new widget page
          Then I should see "Widget is new"
      """
    When I run "cucumber features/widget_is_newed_by_visitor.feature"
    Then I should see:
      """
      1 scenario (1 passed)
      2 steps
      """

