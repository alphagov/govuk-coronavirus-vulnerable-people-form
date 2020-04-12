Feature: Filling in the form
  In order to get help during the Covid-19 pandemic
  As an extremely vulnerable person
  I want to be able to tell my government that I need help
  So that they can support me

  Scenario: Completes the form
    When I visit the "/live-in-england" path
    Then I can see "Do you live in England?" in the heading
    When I answer "Yes"
    Then I can see "Have you recently had a letter from the NHS" in the heading
    When I answer "Yes"
    Then I can see "Do you have one of the listed medical conditions" in the heading
    When I answer "Yes, I have one of the listed medical conditions"
    Then I can see "What is your name?" in the heading
    When I fill in my name
    Then I can see "What is your date of birth?" in the heading
    When I fill in my date of birth
    Then I can see "What is the address" in the heading
    When I fill in my address
    Then I can see "What are your contact details?" in the heading
    When I fill in my contact details
    Then I can see "Do you know your NHS number?" in the heading
    When I answer "Yes"
    Then I can see "What is your NHS number?" in the heading
    When I fill in my nhs number
    Then I can see "Do you have a way of getting essential supplies" in the heading
    When I answer "No"
    Then I can see "Are your basic care needs being met" in the heading
    When I answer "No"
    Then I can see "Do you have any special dietary requirements?" in the heading
    When I answer "No"
    Then I can see "Is there someone in the house who’s able to carry" in the heading
    When I answer "No"
    Then I can see "Are you ready to send your application?" in the heading
    When I click the "Accept and send" button
    Then I can see "Registration complete"

  Scenario: Visits an intermediate question without having previously visited the form
    When I visit the "/essential-supplies" path
    Then I will be redirected to the "/live-in-england" path

  Scenario: Visits the privacy policy
    When I visit the "/live-in-england" path
    And I click the "Privacy" link
    Then I will be redirected to the "/privacy" path
    And I can see "Privacy" in the heading

  Scenario: Not eligible as lives outside England
    When I visit the "/live-in-england" path
    And I answer "No"
    Then I will be redirected to the "/not-eligible-england" path
    And I can see "Sorry, this service is only available in England" in the heading

  Scenario: No eligible medical condition
    When I visit the "/live-in-england" path
    And I answer "Yes"
    And I answer "Yes"
    And I answer "No, I do not have one of the listed medical conditions - and I have not been told to ‘shield’"
    Then I will be redirected to the "/not-eligible-medical" path
    And I can see "Sorry, you’re not eligible for help through this service" in the heading
