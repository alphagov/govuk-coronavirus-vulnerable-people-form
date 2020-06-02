module FormResponseHelper
  def valid_data
    {
      live_in_england: I18n.t("coronavirus_form.questions.live_in_england.options").map { |_, item| item[:label] }.sample,
      nhs_letter: I18n.t("coronavirus_form.questions.nhs_letter.options").map { |_, item| item[:label] }.sample,
      medical_conditions: I18n.t("coronavirus_form.questions.medical_conditions.options").map { |_, item| item[:label] }.sample,
      name: {
        first_name: "Bo",
        middle_name: "Katan",
        last_name: "Kryze",
      },
      date_of_birth: {
        year: "1977",
        month: "5",
        day: "25",
      },
      support_address: {
        building_and_street_line_1: "Building",
        building_and_street_line_2: "Street",
        town_city: "City",
        county: "County",
        postcode: "E1 8QS",
        uprn: "0123456789",
      },
      contact_details: {
        phone_number_calls: "0123456789",
        phone_number_texts: "0123456789",
        email: "me@example.com",
      },
      know_nhs_number: I18n.t("coronavirus_form.questions.know_nhs_number.options").map { |_, item| item[:label] }.sample,
      nhs_number: "4832288822",
      essential_supplies: I18n.t("coronavirus_form.questions.essential_supplies.options").map { |_, item| item[:label] }.sample,
      basic_care_needs: I18n.t("coronavirus_form.questions.basic_care_needs.options").map { |_, item| item[:label] }.sample,
      dietary_requirements: I18n.t("coronavirus_form.questions.dietary_requirements.options").map { |_, item| item[:label] }.sample,
      carry_supplies: I18n.t("coronavirus_form.questions.carry_supplies.options").map { |_, item| item[:label] }.sample,
    }
  end
end
