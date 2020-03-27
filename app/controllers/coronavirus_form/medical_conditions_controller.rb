# frozen_string_literal: true

class CoronavirusForm::MedicalConditionsController < ApplicationController
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
    elsif session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      redirect_to not_eligible_medical_path
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_path
    else
      redirect_to know_nhs_number_path
    end
  end

private

  PAGE = "medical_conditions"

  def previous_path
    contact_details_path
  end
end
