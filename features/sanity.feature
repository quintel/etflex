Feature: Developer sanity
  In order to ensure my sanity
  As a developer of ETFlex
  I want to test that the application is correctly set up

  @javascript
  Scenario: Visiting the sanity test page
    Given I go to the test page
    Then I should see that the page loaded

  @javascript
  Scenario: Visiting the sanity test page
    Given I go to the test page
    When I follow "the ETLite page"
    Then I should see the ETLite recreation
