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

  Scenario: Visits an intermediate question without having previously visited the form
    When I visit the "/essential-supplies" path
    Then I will be redirected to the "/live-in-england" path

  Scenario: Visits the privacy policy
    When I visit the "/live-in-england" path
    And I click the "Privacy" link
    Then I will be redirected to the "/privacy" path
    And I can see a "Privacy" heading

  Scenario: Not eligible as lives outside England
    When I visit the "/live-in-england" path
    And I choose "No"
    And I click the "Continue" button
    Then I will be redirected to the "/not-eligible-england" path
    And I can see a "Sorry, this service is only available in England" heading

  Scenario: No eligible medical condition
    When I visit the "/live-in-england" path
    And I choose "Yes"
    And I click the "Continue" button
    And I choose "Yes"
    And I click the "Continue" button
    And I fill in my name
    And I click the "Continue" button
    And I fill in my date of birth
    And I click the "Continue" button
    And I fill in my address
    And I click the "Continue" button
    And I fill in my contact details
    And I click the "Continue" button
    And I choose "No, I do not have one of the medical conditions on the list"
    And I click the "Continue" button
    Then I will be redirected to the "/not-eligible-medical" path
    And I can see a "Sorry, you’re not eligible for help through this service" heading
