Feature: Developer sanity
  In order to ensure my sanity
  As a developer of ETFlex
  I want to test that the application is correctly set up

  Scenario: Visiting the sanity test page
    Given I go to the test page
    Then I should see that I am sane
