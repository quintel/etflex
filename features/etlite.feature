Feature: The ETlite recreation

  @javascript
  Scenario: Loading the ETlite page
    When I go to the ETlite page
    Then I should see a "Low-energy lighting" range
      And the "Low-energy lighting" range value should be "0"
      And I should see an "Electric cars" range
      And the "Electric cars" range value should be "0"
