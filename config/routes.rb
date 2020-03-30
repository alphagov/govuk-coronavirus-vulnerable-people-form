# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  get "/", to: redirect("https://www.gov.uk/coronavirus-extremely-vulnerable")

  scope module: "coronavirus_form" do
    get "/privacy", to: "privacy#show"
    get "/accessibility-statement", to: "accessibility_statement#show"

    get "/session-expired", to: "session_expired#show"

    # (v4[sunday]) Question 1: Do you live in England?
    get "/live-in-england", to: "live_in_england#show"
    post "/live-in-england", to: "live_in_england#submit"

    # (v4[sunday]) Question 2: Have you recently had a letter from the NHS...
    get "/nhs-letter", to: "nhs_letter#show"
    post "/nhs-letter", to: "nhs_letter#submit"

    # (v4[sunday]) Question 3: What is your name?
    get "/name", to: "name#show"
    post "/name", to: "name#submit"

    # (v4[sunday]) Question 4: What is your date of birth?
    get "/date-of-birth", to: "date_of_birth#show"
    post "/date-of-birth", to: "date_of_birth#submit"

    # (v4[sunday]) Question 5: Address where support is needed
    get "/support-address", to: "support_address#show"
    post "/support-address", to: "support_address#submit"

    # (v4[sunday]) Question 6: Enter your contact details
    get "/contact-details", to: "contact_details#show"
    post "/contact-details", to: "contact_details#submit"

    # (v4[sunday]) Question 7: Do you have a medical condition that makes you vulnerable to coronavirus?
    get "/medical-conditions", to: "medical_conditions#show"
    post "/medical-conditions", to: "medical_conditions#submit"

    # (v4[sunday]) Question 8.1: Do you know your NHS number?
    get "/know-nhs-number", to: "know_nhs_number#show"
    post "/know-nhs-number", to: "know_nhs_number#submit"

    # (v4[sunday]) Question 8.2: What is your NHS number
    get "/nhs-number", to: "nhs_number#show"
    post "/nhs-number", to: "nhs_number#submit"

    # (v4[sunday]) Question 9: Do you have a way of getting essential supplies delivered?
    get "/essential-supplies", to: "essential_supplies#show"
    post "/essential-supplies", to: "essential_supplies#submit"

    # (v4[sunday]) Question 10: Are your basic care needs being met at the moment?
    get "/basic-care-needs", to: "basic_care_needs#show"
    post "/basic-care-needs", to: "basic_care_needs#submit"

    # (v4[sunday]) Question 11: Do you have any special dietary requirements?
    get "/dietary-requirements", to: "dietary_requirements#show"
    post "/dietary-requirements", to: "dietary_requirements#submit"

    # (v4[sunday]) Question 12: Is there someone in the house who's able to carry a delivery of supplies inside?
    get "/carry-supplies", to: "carry_supplies#show"
    post "/carry-supplies", to: "carry_supplies#submit"

    # Check answers page
    get "/check-your-answers", to: "check_answers#show"
    post "/check-your-answers", to: "check_answers#submit"

    # Not eligible for supplies
    get "/not-eligible-medical", to: "not_eligible_medical#show"

    # Person isn't eligible if not in England
    get "/not-eligible-england", to: "not_eligible_england#show"

    # Final page
    get "/confirmation", to: "confirmation#show"
  end
end
