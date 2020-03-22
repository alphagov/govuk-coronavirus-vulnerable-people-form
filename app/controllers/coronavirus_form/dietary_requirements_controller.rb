# frozen_string_literal: true

class CoronavirusForm::DietaryRequirementsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    dietary_requirements = sanitize(params[:dietary_requirements]).presence
    session[:dietary_requirements] = dietary_requirements

    invalid_fields = validate_radio_field(
      PAGE,
      radio: dietary_requirements,
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

  PAGE = "dietary_requirements"
  NEXT_PAGE = "start" # TODO changeme

  def previous_path
    "/" # TODO
  end
end
