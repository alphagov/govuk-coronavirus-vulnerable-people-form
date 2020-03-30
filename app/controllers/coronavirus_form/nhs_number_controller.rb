# frozen_string_literal: true

class CoronavirusForm::NhsNumberController < ApplicationController
  include NhsNumberValidatorHelper

  def submit
    session[:nhs_number] ||= ""
    session[:nhs_number] = sanitize(clean_nhs_number(params["nhs_number"])).presence

    invalid_fields = validate_fields(session[:nhs_number])

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    else
      redirect_to essential_supplies_url
    end
  end

private

  def clean_nhs_number(unclean_nhs_number)
    unclean_nhs_number&.gsub(" ", "")
  end

  def validate_fields(nhs_number)
    validation_response = validate_nhs_number_correctness(nhs_number)
    return [] if validation_response[:valid]

    [
      {
        field: "nhs_number",
        text: validation_response[:message],
      },
    ]
  end

  def previous_path
    know_nhs_number_path
  end
end
