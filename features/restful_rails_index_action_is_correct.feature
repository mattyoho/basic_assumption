Feature: Restful Rails Index Action Is Correct

  Background:
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widgets
        assume :widget
      end
      """

  Scenario: restful index
    Given a file named "app/views/widgets/index.html.erb" with:
      """
      <ul>
      <% widgets.each do |widget| %>
        <li><%= widget.name %></li>
      <% end %>
      </ul>
      """
    And a file named "features/all_widgets_are_viewed_by_visitor.feature" with:
      """
      Feature: All widgets are viewed by visitor
        Scenario: success
          Given the following widgets:
            | name   |
            | John   |
            | Paul   |
            | George |
            | Ringo  |
          When I view all widgets
          Then I should see "John"
          And I should see "Paul"
          And I should see "George"
          And I should see "Ringo"
      """
    When I run `cucumber features/all_widgets_are_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      6 steps
      """

  Scenario: restful index with additional singular assume
    Given a file named "app/views/widgets/index.html.erb" with:
      """
      <ul>
      <% widgets.each do |widget| %>
        <li><%= widget.name %></li>
      <% end %>
      </ul>

      <% if widget.new_record? %>
        New widget
      <% end %>
      """
    And a file named "features/all_widgets_and_a_new_widget_are_viewed_by_visitor.feature" with:
      """
      Feature: All widgets and a new widget are viewed by visitor
        Scenario: success
          Given the following widgets:
            | name     |
            | Alvin    |
            | Simon    |
            | Theodore |
          When I view all widgets
          Then I should see "Alvin"
          And I should see "Simon"
          And I should see "Theodore"
          And I should see "New widget"
      """
    When I run `cucumber features/all_widgets_and_a_new_widget_are_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      6 steps
      """

  Scenario: restful index with additional singular assume and there is an id in params
    Given a file named "app/views/widgets/index.html.erb" with:
      """
      <ul>
      <% widgets.each do |widget| %>
        <li><%= widget.name %></li>
      <% end %>
      </ul>

      <%= widget.name %>
      """
    And a file named "features/all_widgets_and_a_singular_widget_are_viewed_by_visitor.feature" with:
      """
      Feature: All widgets and a singular widget are viewed by visitor
        Scenario: success
          Given the following widgets:
            | name     |
            | Alvin    |
            | Simon    |
            | Theodore |
          And a widget named "sprocket"
          When I view all widgets and there is an id in params
          Then I should see "Alvin"
          And I should see "Simon"
          And I should see "Theodore"
          And I should see "sprocket"
      """
    When I run `cucumber features/all_widgets_and_a_singular_widget_are_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      7 steps
      """
