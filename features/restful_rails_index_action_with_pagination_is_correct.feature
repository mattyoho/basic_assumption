Feature: Restful Rails Index Action With Pagination Is Correct

  Background:
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widgets
        assume :widget
      end
      """
    And a file named "app/views/widgets/index.html.erb" with:
      """
      <ul>
      <% widgets.each do |widget| %>
        <li><%= widget.name %></li>
      <% end %>
      </ul>
      """

  Scenario: restful index first page
    Given a file named "features/first_half_of_widgets_are_viewed_by_visitor.feature" with:
      """
      Feature: First half of widgets are viewed by visitor
        Scenario: success
          Given the following widgets:
            | name   |
            | John   |
            | Paul   |
            | George |
            | Ringo  |
            | Dick   |
            | Tim    |
            | Jason  |
            | Damian |
          When I view page 1 of all widgets with 4 per page
          Then I should see "John"
          And I should see "Paul"
          And I should see "George"
          And I should see "Ringo"
          And I should not see "Dick"
          And I should not see "Tim"
          And I should not see "Jason"
          And I should not see "Damian"
      """
    When I run `cucumber features/first_half_of_widgets_are_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      10 steps
      """

  Scenario: restful index second page
    Given a file named "features/second_half_of_widgets_are_viewed_by_visitor.feature" with:
      """
      Feature: First half of widgets are viewed by visitor
        Scenario: success
          Given the following widgets:
            | name   |
            | John   |
            | Paul   |
            | George |
            | Ringo  |
            | Dick   |
            | Tim    |
            | Damian |
            | Jason  |
          When I view page 3 of all widgets with 2 per page
          Then I should not see "John"
          And I should not see "Paul"
          And I should not see "George"
          And I should not see "Ringo"
          And I should see "Dick"
          And I should see "Tim"
          And I should not see "Jason"
          And I should not see "Damian"
      """
    When I run `cucumber features/second_half_of_widgets_are_viewed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      10 steps
      """
