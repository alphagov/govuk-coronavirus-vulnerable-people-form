# frozen_string_literal: true

class CoronavirusForm::MedicalConditionsController < ApplicationController
  def submit
    @form_responses = {
    medical_conditions: strip_tags(params[:medical_conditions]).presence,
  }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:medical_conditions],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif @form_responses[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label")
      session[:medical_conditions] = @form_responses[:medical_conditions]
      redirect_to not_eligible_medical_url
    elsif session[:check_answers_seen]
      session[:medical_conditions] = @form_responses[:medical_conditions]
      redirect_to check_your_answers_url
    else
      session[:medical_conditions] = @form_responses[:medical_conditions]
      redirect_to name_url
    end
  end

private

  def previous_path
    nhs_letter_path
  end
end
