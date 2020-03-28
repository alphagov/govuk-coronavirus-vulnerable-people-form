# frozen_string_literal: true

class CoronavirusForm::BasicCareNeedsController < ApplicationController
  def submit
    basic_care_needs = sanitize(params[:basic_care_needs]).presence
    session[:basic_care_needs] = basic_care_needs

    invalid_fields = validate_radio_field(
      controller_name,
      radio: basic_care_needs,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path, status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    else
      redirect_to dietary_requirements_url
    end
  end

private

  def previous_path
    essential_supplies_path
  end
end
