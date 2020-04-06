# frozen_string_literal: true

class CoronavirusForm::EssentialSuppliesController < ApplicationController
  def submit
    @form_responses = {
      essential_supplies: strip_tags(params[:essential_supplies]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:essential_supplies],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      session[:essential_supplies] = @form_responses[:essential_supplies]
      redirect_to check_your_answers_url
    else
      session[:essential_supplies] = @form_responses[:essential_supplies]
      redirect_to basic_care_needs_url
    end
  end

private

  def previous_path
    return nhs_number_path if session[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")

    know_nhs_number_path
  end
end
