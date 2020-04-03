# frozen_string_literal: true

class CoronavirusForm::BasicCareNeedsController < ApplicationController
  def submit
    @form_responses = {
      basic_care_needs: strip_tags(params[:basic_care_needs]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:basic_care_needs],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      session[:basic_care_needs] = @form_responses[:basic_care_needs]
      redirect_to check_your_answers_url
    else
      session[:basic_care_needs] = @form_responses[:basic_care_needs]
      redirect_to dietary_requirements_url
    end
  end

private

  def previous_path
    essential_supplies_path
  end
end
