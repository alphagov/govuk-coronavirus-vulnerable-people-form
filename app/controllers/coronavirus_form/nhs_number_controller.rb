# frozen_string_literal: true

class CoronavirusForm::NhsNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    nhs_number = sanitize(params[:nhs_number]).presence
    session[:nhs_number] = nhs_number

    invalid_fields = validate_mandatory_text_fields([:nhs_number], PAGE)

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end

  end
private

  PAGE = "nhs_number"
  NEXT_PAGE = "check_answers" # TODO change to address

  def previous_path
    "/" # TODO
  end
end
