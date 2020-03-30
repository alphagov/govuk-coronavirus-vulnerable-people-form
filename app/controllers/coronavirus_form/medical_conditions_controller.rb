# frozen_string_literal: true

class CoronavirusForm::MedicalConditionsController < ApplicationController
  def submit
    medical_conditions = strip_tags(params[:medical_conditions]).presence
    session[:medical_conditions] = medical_conditions

    invalid_fields = validate_radio_field(
      controller_name,
      radio: medical_conditions,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      redirect_to not_eligible_medical_url
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    else
      redirect_to know_nhs_number_url
    end
  end

private

  def previous_path
    contact_details_path
  end
end
