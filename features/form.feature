Feature: Filling in the form
  In order to complete the form
  As a user
  I want to be able to answer questions

  Scenario: Visits the start page
    When I visit the start page
    Then I can see the page is a work in progress
    And I click the Start now button
    Then I will be redirected to the start page

  Scenario: Visits the basic care needs page
    When I visit the basic care needs page
    Then I can see the basic_care_needs page content
    And I can see the basic_care_needs radio button options
    And I choose Yes
    And I click the Continue button
    Then I will be redirected to the dietary requirements page
