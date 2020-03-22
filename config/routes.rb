# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  # Start page
  get "/", to: "coronavirus_form/start#show"

  # (v3) Question 1: Have you recently had a letter from the NHS...
  get "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#show"
  post "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#submit"

  # (v3) Question 2: Do you have a medical condition that makes you vulnerable to coronavirus?
  get "/coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#show"
  post "coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#submit"

  # (v3) Question 3: What is your name?
  get "/coronavirus-form/name", to: "coronavirus_form/name#show"
  post "coronavirus-form/name", to: "coronavirus_form/name#submit"

  # (v3) Question 4: What is your date of birth?
  get "/coronavirus-form/date-of-birth", to: "coronavirus_form/date_of_birth#show"
  post "/coronavirus-form/date-of-birth", to: "coronavirus_form/date_of_birth#submit"

  # (v3) Question 5: Address where support is needed
  get "/coronavirus-form/support-address" => "coronavirus_form/support_address#show"
  post "/coronavirus-form/support-address" => "coronavirus_form/support_address#submit"

  # (v3) Question 6: Enter your contact details
  get "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#show"
  post "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#submit"

  # (v3) Question 7: Enter your contact details
  get "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#show"
  post "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#submit"

  # (v3) Question 8: What is your NHS number
  get "/coronavirus-form/what-is-your-nhs-number" => "coronavirus_form/nhs_number#show"
  post "/coronavirus-form/what-is-your-nhs-number" => "coronavirus_form/nhs_number#submit"

  # (v3) Question 9: Do you have a way of getting essential supplies delivered?
  get "/coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#show"
  post "coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#submit"

  # (v3) Question 10: Are your basic care needs being met at the moment?
  get "/coronavirus-form/basic-care-needs", to: "coronavirus_form/basic_care_needs#show"
  post "coronavirus-form/basic-care-needs", to: "coronavirus_form/basic_care_needs#submit"

  # (v3) Question 11: Do you have any special dietary requirements?
  get "/coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#show"
  post "coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#submit"

  # (v3) Question 12: Is there someone in the house who's able to carry a delivery of supplies inside?
  get "/coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#show"
  post "coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#submit"

  # (v3) Question 13: Have you been tested for coronavirus?
  get "/coronavirus-form/virus-test", to: "coronavirus_form/virus_test#show"
  post "/coronavirus-form/virus-test", to: "coronavirus_form/virus_test#submit"

  # (v3) Question 14: Do you have a high temperature or a new, continuous cough?
  get "/coronavirus-form/temperature-or-cough", to: "coronavirus_form/temperature_or_cough#show"
  post "/coronavirus-form/temperature-or-cough", to: "coronavirus_form/temperature_or_cough#submit"

  # Check answers page
  get "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#show"
  post "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#submit"

  # Not eligible for supplies
  get "/coronavirus-form/not-eligible-medical" => "coronavirus_form/not_eligible_medical#show"

  # Check answers page
  get "/coronavirus-form/not-eligible-supplies" => "coronavirus_form/not_eligible_supplies#show"

  # Final page
  get "/coronavirus-form/confirmation" => "coronavirus_form/confirmation#show"

  # Removed?
  get "/coronavirus-form/addiction", to: "coronavirus_form/addiction#show"
  post "/coronavirus-form/addiction", to: "coronavirus_form/addiction#submit"
end
