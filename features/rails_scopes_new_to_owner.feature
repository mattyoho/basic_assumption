Feature: Rails New Action Scoped To Owner

  Scenario: Restful new with scoping
    Given a file named "app/controllers/authenticating_controller.rb" with:
      """
      class User
        attr_accessor :id
      end

      class AuthenticatingController < ApplicationController
        def current_user
          User.new.tap {|u| u.id = 42}
        end
      end
      """
    And a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < AuthenticatingController
        default_assumption :rails
        assume :widget, :owner => :current_user
      end
      """
    And a file named "app/views/widgets/new.html.erb" with:
      """
      <% if widget.new_record? && widget.user_id == 42%>
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
    When I run `cucumber features/widget_is_newed_by_visitor.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      2 steps
      """
