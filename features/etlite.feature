Feature: The ETlite recreation

  @javascript
  Scenario: Loading the ETlite page
    When I go to the ETlite page
    Then I should see an "Energy-saving bulbs" slider
      And the "Energy-saving bulbs" slider value should be "0"
      And I should see an "Electric cars" slider
      And the "Electric cars" slider value should be "0"
