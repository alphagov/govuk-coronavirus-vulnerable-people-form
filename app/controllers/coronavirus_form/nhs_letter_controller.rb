# frozen_string_literal: true

class CoronavirusForm::NhsLetterController < ApplicationController
  def submit
    @form_responses = {
      nhs_letter: strip_tags(params[:nhs_letter]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:nhs_letter],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif @form_responses[:nhs_letter] != I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
      set_session_values
      redirect_to medical_conditions_url
    elsif session[:check_answers_seen]
      set_session_values
      redirect_to check_your_answers_url
    elsif @form_responses[:nhs_letter] == I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
      set_session_values
      redirect_to name_url
    end
  end

private

  def set_session_values
    session[:nhs_letter] = @form_responses[:nhs_letter]
    session[:medical_conditions] = nil if @form_responses[:nhs_letter] == I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
  end

  def previous_path
    live_in_england_path
  end
end
