# frozen_string_literal: true

module FillInTheFormSteps
  def given_an_extremely_vulnerable_person_during_the_covid_19_pandemic
    visit live_in_england_path
  end

  def that_lives_in_england
    expect(page).to have_content(I18n.t("coronavirus_form.questions.live_in_england.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def who_does_not_live_in_england
    expect(page).to have_content(I18n.t("coronavirus_form.questions.live_in_england.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.live_in_england.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_recently_received_an_nhs_letter
    expect(page).to have_content(I18n.t("coronavirus_form.questions.nhs_letter.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_not_recently_received_an_nhs_letter
    expect(page).to have_content(I18n.t("coronavirus_form.questions.nhs_letter.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.nhs_letter.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def who_has_a_listed_medical_condition
    expect(page).to have_content(I18n.t("coronavirus_form.questions.medical_conditions.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def who_does_not_have_a_listed_medical_condition
    expect(page).to have_content(I18n.t("coronavirus_form.questions.medical_conditions.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_given_their_name
    expect(page).to have_content(I18n.t("coronavirus_form.questions.name.title"))
    within find(".govuk-main-wrapper") do
      fill_in "first_name", with: "Test Please Ignore"
      fill_in "middle_name", with: "Test Please Ignore"
      fill_in "last_name", with: "Test Please Ignore"
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_given_their_date_of_birth
    expect(page).to have_content(I18n.t("coronavirus_form.questions.date_of_birth.title"))
    within find(".govuk-main-wrapper") do
      fill_in "date_of_birth-day", with: "1"
      fill_in "date_of_birth-month", with: "1"
      fill_in "date_of_birth-year", with: "1970"
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_given_their_postcode
    VCR.turn_on!
    VCR.use_cassette "/postcode/valid_postcode" do
      expect(page).to have_content(I18n.t("coronavirus_form.questions.postcode_lookup.title"))
      within find(".govuk-main-wrapper") do
        fill_in "postcode", with: "SW1A2AA"
        click_on I18n.t("coronavirus_form.submit_and_next")
      end
    end
    VCR.turn_off!
  end

  def and_has_selected_their_address
    expect(page).to have_content(I18n.t("coronavirus_form.questions.address_lookup.title"))
    within find(".govuk-main-wrapper") do
      address = "10, DOWNING STREET, LONDON, CITY OF WESTMINSTER, SW1A 2AA"
      select(address, from: :address)
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_submited_their_address
    expect(page).to have_content(I18n.t("coronavirus_form.questions.support_address.title"))
    within find(".govuk-main-wrapper") do
      fill_in "building_and_street_line_1", with: "Test Please Ignore"
      fill_in "building_and_street_line_2", with: "Test Please Ignore"
      fill_in "town_city", with: "Test Please Ignore"
      fill_in "county", with: "Test Please Ignore"
      fill_in "postcode", with: "ZZ99 9ZZ"
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_given_their_contact_details
    expect(page).to have_content(I18n.t("coronavirus_form.questions.contact_details.title"))
    within find(".govuk-main-wrapper") do
      fill_in "phone_number_calls", with: Rails.application.config.test_telephone_number
      fill_in "phone_number_texts", with: Rails.application.config.test_telephone_number
      fill_in "email", with: Rails.application.config.courtesy_copy_email
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_checked_their_contact_details
    expect(page).to have_content(I18n.t("coronavirus_form.questions.check_contact_details.title"))
    within find(".govuk-main-wrapper") do
      click_on I18n.t("coronavirus_form.questions.check_contact_details.submit_and_next")
    end
  end

  def and_has_given_their_nhs_number
    expect(page).to have_content(I18n.t("coronavirus_form.questions.nhs_number.title"))
    within find(".govuk-main-wrapper") do
      fill_in "nhs_number", with: "1111111111"
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_is_not_getting_any_essential_supplies
    expect(page).to have_content(I18n.t("coronavirus_form.questions.essential_supplies.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.essential_supplies.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_their_basic_care_needs_are_not_being_met
    expect(page).to have_content(I18n.t("coronavirus_form.questions.basic_care_needs.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.basic_care_needs.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_does_not_have_any_special_dietary_requirements
    expect(page).to have_content(I18n.t("coronavirus_form.questions.dietary_requirements.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.dietary_requirements.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def where_there_is_no_one_available_to_carry_supplies
    expect(page).to have_content(I18n.t("coronavirus_form.questions.carry_supplies.title"))
    within find(".govuk-main-wrapper") do
      choose I18n.t("coronavirus_form.questions.carry_supplies.options.option_no.label")
      click_on I18n.t("coronavirus_form.submit_and_next")
    end
  end

  def and_has_accepted_the_terms_and_conditions
    expect(page).to have_content(I18n.t("check_your_answers.title"))
    within find(".govuk-main-wrapper") do
      click_on I18n.t("check_your_answers.submit")
    end
  end

  def then_they_can_be_supported
    expect(page).to have_content(I18n.t("coronavirus_form.confirmation.title"))
  end
end
