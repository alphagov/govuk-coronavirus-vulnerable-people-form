# frozen_string_literal: true

class CoronavirusForm::KnowNhsNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    know_nhs_number = sanitize(params[:know_nhs_number]).presence
    session[:know_nhs_number] = know_nhs_number

    invalid_fields = validate_radio_field(
      PAGE,
      radio: know_nhs_number,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    elsif session[:know_nhs_number] == I18n.t("coronavirus_form.know_nhs_number.options.option_no.label")
      redirect_to controller: "coronavirus_form/essential_supplies", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "know_nhs_number"
  NEXT_PAGE = "check_answers"

  def previous_path
    coronavirus_form_contact_details_path
  end
end
