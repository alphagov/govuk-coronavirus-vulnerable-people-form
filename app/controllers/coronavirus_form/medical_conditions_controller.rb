# frozen_string_literal: true

class CoronavirusForm::MedicalConditionsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    medical_conditions = sanitize(params[:medical_conditions]).presence
    session[:medical_conditions] = medical_conditions

    invalid_fields = validate_radio_field(
      PAGE,
      radio: medical_conditions,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    elsif session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      redirect_to controller: "coronavirus_form/not_eligible_medical", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "medical_conditions"
  NEXT_PAGE = "know_nhs_number"

  def previous_path
    coronavirus_form_contact_details_path
  end
end
