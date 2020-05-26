# frozen_string_literal: true

class CoronavirusForm::CheckContactDetailsController < ApplicationController

  def submit
    @form_responses = {
      contact_details: {
        email: strip_tags(params[:email]&.strip).presence,
      },
    }

    invalid_fields = [
      @form_responses[:contact_details].dig(:email) ? validate_email_address("email", @form_responses.dig(:contact_details, :email)) : [],
    ].flatten.compact

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
      redirect_to nhs_number_url
    end
  end

private

  def update_session_store
    session[:contact_details].merge!(@form_responses[:contact_details])
  end

  def previous_path
    contact_details_path
  end
end
