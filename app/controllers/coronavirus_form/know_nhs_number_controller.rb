# frozen_string_literal: true

class CoronavirusForm::KnowNhsNumberController < ApplicationController
  def submit
    know_nhs_number = sanitize(params[:know_nhs_number]).presence
    session[:know_nhs_number] = know_nhs_number

    session[:nhs_number] = nil if I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label")

    invalid_fields = validate_radio_field(
      controller_name,
      radio: know_nhs_number,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render controller_path, status: :unprocessable_entity
    elsif session[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")
      redirect_to nhs_number_url
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    elsif session[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label")
      redirect_to essential_supplies_url
    end
  end

private

  def previous_path
    medical_conditions_path
  end
end
