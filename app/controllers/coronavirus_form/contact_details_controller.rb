# frozen_string_literal: true

class CoronavirusForm::ContactDetailsController < ApplicationController
  def submit
    @form_responses = {
      contact_details: {
        phone_number_calls: strip_tags(params[:phone_number_calls]&.strip).presence,
        phone_number_texts: strip_tags(params[:phone_number_texts]&.strip).presence,
        email: strip_tags(params[:email]&.strip).presence,
      },
    }

    invalid_fields = if @form_responses[:contact_details].dig(:email)
                       validate_email_address("email", @form_responses.dig(:contact_details, :email))
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
      session[:contact_details] = @form_responses[:contact_details]
      redirect_to check_your_answers_url
    else
      session[:contact_details] = @form_responses[:contact_details]
      redirect_to know_nhs_number_url
    end
  end

private

  def previous_path
    support_address_path
  end
end
