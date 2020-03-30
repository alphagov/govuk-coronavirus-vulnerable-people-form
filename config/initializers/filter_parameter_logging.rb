# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[password email name first_name middle_name last_name nhs_number nhs_letter date_of_birth carry_supplies live_in_england phone_number_calls phone_number_texts know_nhs_number basic_care_needs essential_supplies medical_conditions dietary_requirements building_and_street_line_1 building_and_street_line_2 town_city county postcode]
