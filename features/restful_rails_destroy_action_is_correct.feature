Feature: Restful Rails Destroy Action Is Correct

  Scenario: restful destroy
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widget
        assume :widgets

        def destroy
          widget.destroy
          redirect_to widgets_path
        end
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
    Given a file named "app/views/widgets/show.html.erb" with:
      """
      <%= widget.name unless widget.frozen? %>
      <% form_for widget do |form| %>
        <%= hidden_field_tag '_method', 'delete' %>
        <%= submit_tag "Delete" %>
      <% end %>
      """
    And a file named "features/widget_is_deleted_by_visitor.feature" with:
      """
      Feature: Widget is deleted by visitor
        Scenario: success
          Given a widget named "spacely"
          And a widget named "sprocket"
          When I view the widget
          And I press "Delete"
          Then I should not see "sprocket"
          And I should see "spacely"
      """
    When I run "cucumber features/widget_is_deleted_by_visitor.feature"
    Then I should see:
      """
      1 scenario (1 passed)
      6 steps
      """
