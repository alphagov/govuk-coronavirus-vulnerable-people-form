# frozen_string_literal: true

class CoronavirusForm::DateOfBirthController < ApplicationController
  def show
    session["date_of_birth"] ||= {}
    super
  end

  def submit
    session["date_of_birth"] ||= {}
    session["date_of_birth"]["day"] = sanitize(params.dig("date_of_birth", "day")&.strip).presence
    session["date_of_birth"]["month"] = sanitize(params.dig("date_of_birth", "month")&.strip).presence
    session["date_of_birth"]["year"] = sanitize(params.dig("date_of_birth", "year")&.strip).presence

    invalid_fields = validate_date_of_birth(
      session["date_of_birth"]["year"],
      session["date_of_birth"]["month"],
      session["date_of_birth"]["day"],
      "date_of_birth",
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_url
    else
      redirect_to support_address_url
    end
  end

private

  def previous_path
    name_path
  end
end
