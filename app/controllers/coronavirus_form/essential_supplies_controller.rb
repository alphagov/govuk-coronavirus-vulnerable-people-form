# frozen_string_literal: true

class CoronavirusForm::EssentialSuppliesController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    essential_supplies = strip_tags(params[:essential_supplies]).presence
    session[:essential_supplies] = essential_supplies

    invalid_fields = validate_radio_field(
      PAGE,
      radio: essential_supplies,
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

  PAGE = "essential_supplies"
  NEXT_PAGE = "basic_care_needs"

  def previous_path
    return nhs_number_path if session[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")

    know_nhs_number_path
  end
end
