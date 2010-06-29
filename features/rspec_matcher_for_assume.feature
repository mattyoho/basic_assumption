Feature: RSpec Matcher For Assume

  Scenario: Controller spec uses the simple matcher
    Given a file named "app/controllers/widgets_controller.rb" with:
      """
      class WidgetsController < ApplicationController
        assume :widget
      end
      """
    And a file named "spec/controllers/widgets_controller_spec.rb" with:
      """
      require 'spec_helper'
      require 'basic_assumption/rspec'
      describe WidgetsController do
        it { should assume(:widget) }
        it { should_not assume(:sprocket) }
      end
      """
    When I run "spec spec/controllers/widgets_controller_spec.rb"
    Then I should see:
      """
      2 examples, 0 failures
      """

