# frozen_string_literal: true

class CoronavirusForm::KnowNhsNumberController < ApplicationController
  def submit
    @form_responses = {
      know_nhs_number: strip_tags(params[:know_nhs_number]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:know_nhs_number],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif @form_responses[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")
      set_session_values
      redirect_to nhs_number_url
    elsif session[:check_answers_seen]
      set_session_values
      redirect_to check_your_answers_url
    elsif @form_responses[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label")
      set_session_values
      redirect_to essential_supplies_url
    end
  end

private

  def set_session_values
    session[:know_nhs_number] = @form_responses[:know_nhs_number]
    session[:nhs_number] = nil if @form_responses[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label")
  end

  def previous_path
    contact_details_path
  end
end
