# frozen_string_literal: true

class CoronavirusForm::DietaryRequirementsController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    dietary_requirements = sanitize(params[:dietary_requirements]).presence
    session[:dietary_requirements] = dietary_requirements

    invalid_fields = validate_radio_field(
      PAGE,
      radio: dietary_requirements,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_path
    else
      redirect_to carry_supplies_path
    end
  end

private

  PAGE = "dietary_requirements"

  def previous_path
    basic_care_needs_path
  end
end
