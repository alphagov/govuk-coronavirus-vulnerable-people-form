# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  # Start page
  get "/", to: "coronavirus_form/start#show"

  # Question pages
  get "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#show"
  post "/coronavirus-form/nhs-letter", to: "coronavirus_form/nhs_letter#submit"

  get "/coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#show"
  post "coronavirus-form/medical-conditions", to: "coronavirus_form/medical_conditions#submit"

  get "/coronavirus-form/virus-test", to: "coronavirus_form/virus_test#show"
  post "/coronavirus-form/virus-test", to: "coronavirus_form/virus_test#submit"

  get "/coronavirus-form/addiction", to: "coronavirus_form/addiction#show"
  post "/coronavirus-form/addiction", to: "coronavirus_form/addiction#submit"

  get "/coronavirus-form/temperature-or-cough", to: "coronavirus_form/temperature_or_cough#show"
  post "/coronavirus-form/temperature-or-cough", to: "coronavirus_form/temperature_or_cough#submit"

  # Question 4: Name
  get "/coronavirus-form/name", to: "coronavirus_form/name#show"
  post "coronavirus-form/name", to: "coronavirus_form/name#submit"

  # Question 9: Dietary requirements
  get "/coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#show"
  post "coronavirus-form/dietary-requirements", to: "coronavirus_form/dietary_requirements#submit"

  # Question 10: Essential supplies
  get "/coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#show"
  post "coronavirus-form/essential-supplies", to: "coronavirus_form/essential_supplies#submit"

  # Question: Carry supplies
  get "/coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#show"
  post "coronavirus-form/carry-supplies", to: "coronavirus_form/carry_supplies#submit"

  get "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#show"
  post "/coronavirus-form/contact-details", to: "coronavirus_form/contact_details#submit"

  get "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#show"
  post "/coronavirus-form/know-nhs-number", to: "coronavirus_form/know_nhs_number#submit"

  # Check answers page
  get "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#show"
  post "/coronavirus-form/check-your-answers" => "coronavirus_form/check_answers#submit"

  # Final page
  get "/coronavirus-form/confirmation" => "coronavirus_form/confirmation#show"
end
