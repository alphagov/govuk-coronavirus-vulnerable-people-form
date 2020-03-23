# frozen_string_literal: true

class CoronavirusForm::ContactDetailsController < ApplicationController
  def submit
    contact_details = {
      phone_number_calls: strip_tags(params[:phone_number_calls]&.strip).presence,
      phone_number_texts: strip_tags(params[:phone_number_texts]&.strip).presence,
      email: strip_tags(params[:email]&.strip).presence,
    }
    session[:contact_details] = contact_details

    invalid_fields = if session[:contact_details].dig(:email)
        validate_email_address("email", session[:contact_details].dig(:email))
      else
        []
      end

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      redirect_to check_your_answers_url
    else
      redirect_to medical_conditions_url
    end
  end

private

  def previous_path
    support_address_path
  end
end
