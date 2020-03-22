# frozen_string_literal: true

class CoronavirusForm::DateOfBirthController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session["date_of_birth"] ||= {}
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session["date_of_birth"] ||= {}
    session["date_of_birth"]["day"] = sanitize(params.dig("date_of_birth", "day")).presence
    session["date_of_birth"]["month"] = sanitize(params.dig("date_of_birth", "month")).presence
    session["date_of_birth"]["year"] = sanitize(params.dig("date_of_birth", "year")).presence

    invalid_fields = validate_date_of_birth(
      session["date_of_birth"]["year"],
      session["date_of_birth"]["month"],
      session["date_of_birth"]["day"],
      "date_of_birth",
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

  PAGE = "date_of_birth"
  NEXT_PAGE = "support_address"

  def previous_path
    name_path
  end
end
