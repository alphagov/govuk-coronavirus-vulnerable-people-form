# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  # Start page
  get "/", to: "coronavirus_form/start#show"

  # (v4[sunday]) Question 1: Do you live in England?
  get "/coronavirus-form/live-in-england", to: "coronavirus_form/live_in_england#show"
  post "/coronavirus-form/live-in-england", to: "coronavirus_form/live_in_england#submit"

  # (v4[sunday]) Question 2: Have you recently had a letter from the NHS...
  get "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#show"
  post "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#submit"

  # (v4[sunday]) Question 3: What is your name?
  get "/coronavirus-form/name", to: "coronavirus_form/name#show"
  post "coronavirus-form/name", to: "coronavirus_form/name#submit"

  # (v4[sunday]) Question 4: What is your date of birth?
  get "/coronavirus-form/date-of-birth", to: "coronavirus_form/date_of_birth#show"
  post "/coronavirus-form/date-of-birth", to: "coronavirus_form/date_of_birth#submit"

  # (v4[sunday]) Question 5: Address where support is needed
  get "/coronavirus-form/support-address" => "coronavirus_form/support_address#show"
  post "/coronavirus-form/support-address" => "coronavirus_form/support_address#submit"

  # (v4[sunday]) Question 6: Enter your contact details
  get "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#show"
  post "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#submit"

  # (v4[sunday]) Question 7: Do you have a medical condition that makes you vulnerable to coronavirus?
  get "/coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#show"
  post "coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#submit"

  # (v4[sunday]) Question 8.1: Do you know your NHS number?
  get "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#show"
  post "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#submit"

  # (v4[sunday]) Question 8.2: What is your NHS number
  get "/coronavirus-form/what-is-your-nhs-number" => "coronavirus_form/nhs_number#show"
  post "/coronavirus-form/what-is-your-nhs-number" => "coronavirus_form/nhs_number#submit"

  # (v4[sunday]) Question 9: Do you have a way of getting essential supplies delivered?
  get "/coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#show"
  post "coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#submit"

  # (v4[sunday]) Question 10: Are your basic care needs being met at the moment?
  get "/coronavirus-form/basic-care-needs", to: "coronavirus_form/basic_care_needs#show"
  post "coronavirus-form/basic-care-needs", to: "coronavirus_form/basic_care_needs#submit"

  # (v4[sunday]) Question 11: Do you have any special dietary requirements?
  get "/coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#show"
  post "coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#submit"

  # (v4[sunday]) Question 12: Is there someone in the house who's able to carry a delivery of supplies inside?
  get "/coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#show"
  post "coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#submit"

  # Check answers page
  get "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#show"
  post "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#submit"

  # Not eligible for supplies
  get "/coronavirus-form/not-eligible-medical" => "coronavirus_form/not_eligible_medical#show"

  # Check answers page
  get "/coronavirus-form/not-eligible-supplies" => "coronavirus_form/not_eligible_supplies#show"

  # Final page
  get "/coronavirus-form/confirmation" => "coronavirus_form/confirmation#show"
end
