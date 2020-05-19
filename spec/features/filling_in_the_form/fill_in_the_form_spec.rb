# frozen_string_literal: true

require "spec_helper"

RSpec.feature "fill in the vulnerable people form" do
  include FillInTheFormSteps

  shared_examples "completing the form" do
    scenario "fill in the form" do
      given_an_extremely_vulnerable_person_during_the_covid_19_pandemic
      that_lives_in_england
      and_has_recently_received_an_nhs_letter
      who_has_a_listed_medical_condition
      and_has_given_their_name
      and_has_given_their_date_of_birth
      and_has_given_their_address
      and_has_given_their_contact_details
      and_has_given_their_nhs_number
      and_is_not_getting_any_essential_supplies
      and_their_basic_care_needs_are_not_being_met
      and_does_not_have_any_special_dietary_requirements
      where_there_is_no_one_available_to_carry_supplies
      and_has_accepted_the_terms_and_conditions
      then_they_can_be_supported
    end
  end

  describe "fill in the form" do
    context "without javascript" do
      it_behaves_like "completing the form"
    end

    context "with javascript", js: true do
      it_behaves_like "completing the form"
    end
  end

  scenario "visit an intermediate question without having previously visited the form" do
    visit essential_supplies_path

    expect(page.body).to have_content(I18n.t("coronavirus_form.questions.live_in_england.title"))
  end

  scenario "visitor not eligible as they live outside of England" do
    given_an_extremely_vulnerable_person_during_the_covid_19_pandemic
    who_does_not_live_in_england

    expect(page.body).to have_content(I18n.t("not_eligible_england.title"))
  end

  scenario "visitor not eligible as they do not have a listed medical condition" do
    given_an_extremely_vulnerable_person_during_the_covid_19_pandemic
    that_lives_in_england
    and_has_recently_received_an_nhs_letter
    who_does_not_have_a_listed_medical_condition

    expect(page.body).to have_content(I18n.t("not_eligible_medical.title"))
  end

  scenario "ensure we can perform a healthcheck" do
    visit healthcheck_path

    expect(page.body).to have_content("OK")
  end

  scenario "ensure the privacy notice page is visible" do
    visit privacy_path

    expect(page.body).to have_content(I18n.t("privacy_page.title"))
  end

  scenario "ensure the accessibility statement page is visible" do
    visit accessibility_statement_path

    expect(page.body).to have_content(I18n.t("accessibility_statement.title"))
  end
end
