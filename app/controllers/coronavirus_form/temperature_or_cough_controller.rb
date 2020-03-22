# frozen_string_literal: true

class CoronavirusForm::TemperatureOrCoughController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    temperature_or_cough = sanitize(params[:temperature_or_cough]).presence
    session[:temperature_or_cough] = temperature_or_cough

    invalid_fields = validate_radio_field(
      PAGE,
      radio: temperature_or_cough,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "temperature_or_cough"
  NEXT_PAGE = "check_answers"

  def previous_path
    coronavirus_form_virus_test_path
  end
end
