# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  get "/" => redirect("https://www.gov.uk/coronavirus-extremely-vulnerable")

  get "/privacy", to: "coronavirus_form/privacy#show"

  # (v4[sunday]) Question 1: Do you live in England?
  get "/live-in-england", to: "coronavirus_form/live_in_england#show"
  post "/live-in-england", to: "coronavirus_form/live_in_england#submit"

  # (v4[sunday]) Question 2: Have you recently had a letter from the NHS...
  get "/nhs-letter", to: "coronavirus_form/nhs_letter#show"
  post "/nhs-letter", to: "coronavirus_form/nhs_letter#submit"

  # (v4[sunday]) Question 3: What is your name?
  get "/name", to: "coronavirus_form/name#show"
  post "/name", to: "coronavirus_form/name#submit"

  # (v4[sunday]) Question 4: What is your date of birth?
  get "/date-of-birth", to: "coronavirus_form/date_of_birth#show"
  post "/date-of-birth", to: "coronavirus_form/date_of_birth#submit"

  # (v4[sunday]) Question 5: Address where support is needed
  get "/support-address" => "coronavirus_form/support_address#show"
  post "/support-address" => "coronavirus_form/support_address#submit"

  # (v4[sunday]) Question 6: Enter your contact details
  get "/contact-details", to: "coronavirus_form/contact_details#show"
  post "/contact-details", to: "coronavirus_form/contact_details#submit"

  # (v4[sunday]) Question 7: Do you have a medical condition that makes you vulnerable to coronavirus?
  get "/medical-conditions", to: "coronavirus_form/medical_conditions#show"
  post "/medical-conditions", to: "coronavirus_form/medical_conditions#submit"

  # (v4[sunday]) Question 8.1: Do you know your NHS number?
  get "/know-nhs-number", to: "coronavirus_form/know_nhs_number#show"
  post "/know-nhs-number", to: "coronavirus_form/know_nhs_number#submit"

  # (v4[sunday]) Question 8.2: What is your NHS number
  get "/nhs-number" => "coronavirus_form/nhs_number#show"
  post "/nhs-number" => "coronavirus_form/nhs_number#submit"

  # (v4[sunday]) Question 9: Do you have a way of getting essential supplies delivered?
  get "/essential-supplies", to: "coronavirus_form/essential_supplies#show"
  post "/essential-supplies", to: "coronavirus_form/essential_supplies#submit"

  # (v4[sunday]) Question 10: Are your basic care needs being met at the moment?
  get "/basic-care-needs", to: "coronavirus_form/basic_care_needs#show"
  post "/basic-care-needs", to: "coronavirus_form/basic_care_needs#submit"

  # (v4[sunday]) Question 11: Do you have any special dietary requirements?
  get "/dietary-requirements", to: "coronavirus_form/dietary_requirements#show"
  post "/dietary-requirements", to: "coronavirus_form/dietary_requirements#submit"

  # (v4[sunday]) Question 12: Is there someone in the house who's able to carry a delivery of supplies inside?
  get "/carry-supplies", to: "coronavirus_form/carry_supplies#show"
  post "/carry-supplies", to: "coronavirus_form/carry_supplies#submit"

  # Check answers page
  get "/check-your-answers" => "coronavirus_form/check_answers#show"
  post "/check-your-answers" => "coronavirus_form/check_answers#submit"

  # Not eligible for supplies
  get "/not-eligible-medical" => "coronavirus_form/not_eligible_medical#show"

  # Person isn't eligible if not in England
  get "/not-eligible-england" => "coronavirus_form/not_eligible_england#show"

  # Final page
  get "/confirmation" => "coronavirus_form/confirmation#show"
end
