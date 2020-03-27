# frozen_string_literal: true

class CoronavirusForm::ContactDetailsController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    contact_details = {
      "phone_number_calls" => sanitize(params[:phone_number_calls]&.strip).presence,
      "phone_number_texts" => sanitize(params[:phone_number_texts]&.strip).presence,
      "email" => sanitize(params[:email]&.strip).presence,
    }
    session[:contact_details] = contact_details

    invalid_fields = contact_details["email"] ? validate_email_address("email", contact_details["email"]) : []

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to check_your_answers_path
    else
      redirect_to medical_conditions_path
    end
  end

private

  PAGE = "contact_details"

  def previous_path
    support_address_path
  end
end
