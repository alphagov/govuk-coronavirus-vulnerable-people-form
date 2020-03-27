# frozen_string_literal: true

class CoronavirusForm::NhsLetterController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    nhs_letter = sanitize(params[:nhs_letter]).presence
    session[:nhs_letter] = nhs_letter

    invalid_fields = validate_radio_field(
      PAGE,
      radio: nhs_letter,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_path
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "nhs_letter"
  NEXT_PAGE = "name"

  def previous_path
    live_in_england_path
  end
end
