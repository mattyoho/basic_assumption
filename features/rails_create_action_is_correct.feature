Feature: Rails Create Action Is Correct

  Scenario: restful create
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        default_assumption :rails
        assume :widget

        def create
          widget.save!
          redirect_to widget_path(widget)
        end
      end
      """
    And a file named "app/views/widgets/new.html.erb" with:
      """
      <%= form_for widget do |form| %>
        <%= form.label :name, "Name" %>
        <%= form.text_field :name %>
        <%= submit_tag "Create" %>
      <% end %>
      """
    And a file named "app/views/widgets/show.html.erb" with:
      """
      <% unless widget.new_record? %>
        <span><%= widget.name %></span>
      <% end %>
      """
    And a file named "features/widget_is_created_by_visitor.feature" with:
      """
      Feature: Widget is created by visitor
        Scenario: success
          When I go to the new widget page
          And I fill in "Name" with "created"
          And I press "Create"
          Then I should see "created"
      """
    When I run `cucumber features/widget_is_created_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      4 steps
      """
