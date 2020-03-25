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

  Scenario: Answers "Have you recently had a letter from the NHS about your situation as someone who’s extremely vulnerable to coronavirus?"
    When I visit the "/nhs-letter" path
    Then I can see a "Have you recently had a letter from the NHS about your situation as someone who’s extremely vulnerable to coronavirus?" heading
    And I choose "Not sure"
    And I click the "Continue" button
    Then I will be redirected to the "/name" path
