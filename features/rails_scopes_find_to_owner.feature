Feature: Rails Scopes Find To Owner

  Background:
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
        assume :widget, :owner => :current_user, :raise_error => true

        rescue_from ActiveRecord::RecordNotFound do
          render :text => "Not Found", :status => 404
        end
      end
      """
    And a file named "app/views/widgets/show.html.erb" with:
      """
      <span><%= widget.name %></span>
      """

  Scenario: Scoping with a symbol success
    Given a file named "features/widget_is_viewed_by_owner.feature" with:
      """
      Feature: Find A Record Owned By You
        Scenario: success
          Given I own a widget named "sprocket"
          When  I view the widget
          Then  I should see "sprocket"
      """
    When I run `cucumber features/widget_is_viewed_by_owner.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """

  Scenario: Scoping with a symbol failure
    Given a file named "features/widget_is_viewed_by_owner.feature" with:
      """
      Feature: Don't Find Record Not Belonging To You
        Scenario: success
          Given a widget named "spacely"
          When  I view the widget
          Then  I should see "Not Found"
      """
    When I run `cucumber features/widget_is_viewed_by_owner.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """

  Scenario: Scoping with a hash success
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class Owner
        attr_accessor :id
      end

      class WidgetsController < AuthenticatingController
        default_assumption :rails
        assume :widget, :owner => {:object => :current_owner, :column_name => :user_id}

        def current_owner
          Owner.new.tap {|u| u.id = 42}
        end

        rescue_from ActiveRecord::RecordNotFound do
          render :text => "Not Found", :status => 404
        end
      end
      """
    And a file named "features/widget_is_viewed_by_owner.feature" with:
      """
      Feature: Find A Record Owned By You
        Scenario: success
          Given I own a widget named "sprocket"
          When  I view the widget
          Then  I should see "sprocket"
      """
    When I run `cucumber features/widget_is_viewed_by_owner.feature` with a clean Bundler environment
    Then the output should contain:
      """
      1 scenario (1 passed)
      3 steps
      """
