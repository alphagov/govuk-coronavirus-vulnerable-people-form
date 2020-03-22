# frozen_string_literal: true

class CoronavirusForm::AddictionController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    addiction = sanitize(params[:addiction]).presence
    session[:addiction] = addiction

    invalid_fields = validate_radio_field(
      PAGE,
      radio: addiction,
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

  PAGE = "addiction"
  NEXT_PAGE = "check_answers"

  def previous_path
    "/"
  end
end
