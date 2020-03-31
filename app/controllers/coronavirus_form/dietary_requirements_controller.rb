# frozen_string_literal: true

class CoronavirusForm::DietaryRequirementsController < ApplicationController
  def submit
    dietary_requirements = strip_tags(params[:dietary_requirements]).presence
    session[:dietary_requirements] = dietary_requirements

    invalid_fields = validate_radio_field(
      controller_name,
      radio: dietary_requirements,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      redirect_to check_your_answers_url
    else
      redirect_to carry_supplies_url
    end
  end

private

  def previous_path
    basic_care_needs_path
  end
end
