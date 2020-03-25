Feature: Filling in the form
  In order to get help during the Covid-19 pandemic
  As an extremely vulnerable person
  I want to be able to tell my government that I need help
  So that they can support me

  Scenario: Answers "Do you live in England?"
    When I visit the "/live-in-england" path
    Then I can see a "Do you live in England?" heading
    And I choose "Yes"
    And I click the "Continue" button
    Then I will be redirected to the "/nhs-letter" path

  Scenario: Visits an intermediate question
      When I visit the "/essential-supplies" path
      Then I will be redirected to the "/live-in-england" path
