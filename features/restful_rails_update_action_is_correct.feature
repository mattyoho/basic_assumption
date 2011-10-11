Feature: Restful Rails Update Action Is Correct

  Scenario: restful update
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :restful_rails
        assume :widget

        def update
          widget.update_attributes(params[:widget])
          redirect_to widget_path(widget)
        end
      end
      """
    And a file named "app/views/widgets/edit.html.erb" with:
      """
      <%= form_for widget do |form| %>
        <%= form.label :name, "Name" %>
        <%= form.text_field :name %>
        <%= submit_tag "Update" %>
      <% end %>
      """
    And a file named "app/views/widgets/show.html.erb" with:
      """
      <span><%= widget.name %></span>
      """
    And a file named "features/widget_is_updated_by_visitor.feature" with:
      """
      Feature: Widget is updated by visitor
        Scenario: success
          Given a widget named "before"
          When I edit the widget
          And I fill in "Name" with "after"
          And I press "Update"
          Then I should see "after"
      """
    When I run `cucumber features/widget_is_updated_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      5 steps
      """
