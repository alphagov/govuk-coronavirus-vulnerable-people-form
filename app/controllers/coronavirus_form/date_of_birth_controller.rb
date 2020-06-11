# typed: false
# frozen_string_literal: true

class CoronavirusForm::DateOfBirthController < ApplicationController
  def submit
    @form_responses = {
      date_of_birth: {
        day: strip_tags(params.dig(:date_of_birth, :day)&.strip).presence,
        month: strip_tags(params.dig(:date_of_birth, :month)&.strip).presence,
        year: strip_tags(params.dig(:date_of_birth, :year)&.strip).presence,
      },
    }

    invalid_fields = validate_date_of_birth(
      @form_responses[:date_of_birth].dig(:year),
      @form_responses[:date_of_birth].dig(:month),
      @form_responses[:date_of_birth].dig(:day),
      "date_of_birth",
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      update_session_store
      redirect_to check_your_answers_url
    else
      update_session_store
      redirect_to postcode_lookup_url
    end
  end

private

  def update_session_store
    date_of_birth = DateTime.new(
      @form_responses[:date_of_birth].dig(:year).to_i,
      @form_responses[:date_of_birth].dig(:month).to_i,
      @form_responses[:date_of_birth].dig(:day).to_i,
    )

    session[:date_of_birth] = {
      year: date_of_birth.strftime("%Y"),
      month: date_of_birth.strftime("%m"),
      day: date_of_birth.strftime("%d"),
    }
  end

  def previous_path
    name_path
  end
end
