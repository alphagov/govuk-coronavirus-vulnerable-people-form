# frozen_string_literal: true

class CoronavirusForm::DietaryRequirementsController < ApplicationController
  def submit
    @form_responses = {
      dietary_requirements: strip_tags(params[:dietary_requirements]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:dietary_requirements],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      session[:dietary_requirements] = @form_responses[:dietary_requirements]
      redirect_to check_your_answers_url
    else
      session[:dietary_requirements] = @form_responses[:dietary_requirements]
      redirect_to carry_supplies_url
    end
  end

private

  def previous_path
    basic_care_needs_path
  end
end
