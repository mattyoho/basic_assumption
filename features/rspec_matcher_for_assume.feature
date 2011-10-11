@rails3 @wip
Feature: RSpec Matcher For Assume

  Scenario: Controller spec uses the simple matcher
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class BaseController
        extend BasicAssumption
      end

      class WidgetsController < BaseController
        assume :widget
      end
      """
    And a file named "spec/controllers/widgets_controller_spec.rb" with:
      """
      require 'app/controllers/widgets_controller'
      require 'basic_assumption/rspec'
      describe WidgetsController do
        it { should assume(:widget) }
        it { should_not assume(:sprocket) }
      end
      """
    When I run `bundle exec rspec spec/controllers/widgets_controller_spec.rb` with a clean Bundler environment
    Then the output should contain:
      """
      2 examples, 0 failures
      """

