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

    invalid_fields = [
      @form_responses[:contact_details].dig(:phone_number_calls) ? validate_telephone_number("phone_number_calls", @form_responses.dig(:contact_details, :phone_number_calls)) : [],
      @form_responses[:contact_details].dig(:phone_number_texts) ? validate_telephone_number("phone_number_texts", @form_responses.dig(:contact_details, :phone_number_texts)) : [],
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
      if nhs_account_number_prepopulated_from_nhs_login?
        redirect_to nhs_number_url
      else
        redirect_to know_nhs_number_url
      end
    end
  end

private

  def nhs_account_number_prepopulated_from_nhs_login?
    session[:use_nhs_account] == t("coronavirus_form.preamble.use_nhs_account.options.option_yes.label") \
      && session[:nhs_number] \
      && session[:know_nhs_number] == I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")
  end

  def update_session_store
    @form_responses[:contact_details][:phone_number_calls] = TelephoneNumber.parse(@form_responses[:contact_details][:phone_number_calls], :gb).national_number
    @form_responses[:contact_details][:phone_number_texts] = TelephoneNumber.parse(@form_responses[:contact_details][:phone_number_texts], :gb).national_number
    session[:contact_details] = @form_responses[:contact_details]
  end

  def previous_path
    support_address_path
  end
end
