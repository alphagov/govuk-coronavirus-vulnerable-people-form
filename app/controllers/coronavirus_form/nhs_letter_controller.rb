# frozen_string_literal: true

class CoronavirusForm::NhsLetterController < ApplicationController
  def submit
    nhs_letter = strip_tags(params[:nhs_letter]).presence
    session[:nhs_letter] = nhs_letter

    invalid_fields = validate_radio_field(
      controller_name,
      radio: nhs_letter,
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
      redirect_to name_url
    end
  end

private

  def previous_path
    live_in_england_path
  end
end
