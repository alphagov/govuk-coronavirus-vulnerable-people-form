# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  include AnswersHelper
  include SchemaHelper

  def show
    session[:check_answers_seen] = true
    super
  end

  def submit
    submission_reference = reference_number
    @contact_gp = contact_gp?

    session[:reference_id] = submission_reference

    json_validation = validate_against_form_response_schema(sanitised_session)
    unless json_validation.valid?
      GovukError.notify(
        FormResponseInvalidError.new,
        extra: { validation_errors: json_validation.errors },
      )
    end

    unless smoke_tester? || preview_app?
      FormResponse.create(
        ReferenceId: submission_reference,
        UnixTimestamp: Time.zone.now,
        FormResponse: sanitised_session,
      )

      send_confirmation_email if session.dig(:contact_details, :email).present?
      send_confirmation_sms if session.dig(:contact_details, :phone_number_texts).present? && mobile_number_provided?
    end

    reset_session

    redirect_to confirmation_url(reference_number: submission_reference, contact_gp: @contact_gp)
  end

private

  def smoke_tester?
    email = session.dig(:contact_details, :email)
    mobile_number = session.dig(:contact_details, :phone_number_texts)
    (email.present? && email == Rails.application.config.courtesy_copy_email) || (mobile_number.present? && mobile_number == Rails.application.config.test_telephone_number)
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end

  def send_confirmation_email
    mailer = CoronavirusFormMailer.with(
      first_name: session.dig(:name, :first_name),
      last_name: session.dig(:name, :last_name),
      reference_number: reference_number,
      contact_gp: @contact_gp,
    )
    mailer.confirmation_email(user_email).deliver_later
  end

  def send_confirmation_sms
    mailer = CoronavirusFormMailer.with(
      first_name: session.dig(:name, :first_name),
      last_name: session.dig(:name, :last_name),
      reference_number: reference_number,
      contact_gp: @contact_gp,
    )
    mailer.confirmation_sms(user_mobile_number).deliver_later
  end

  def user_email
    if ENV["PAAS_ENV"] == "staging"
      Rails.application.config.courtesy_copy_email
    else
      session.dig(:contact_details, :email)
    end
  end

  def user_mobile_number
    TelephoneNumber.parse(session.dig(:contact_details, :phone_number_texts), :gb).national_number(formatted: false)
  end

  def mobile_number_provided?
    TelephoneNumber.valid?(session.dig(:contact_details, :phone_number_texts), :gb, [:mobile])
  end

  def sanitised_session
    session.to_h.except("session_id", "_csrf_token", "current_path", "previous_path", "check_answers_seen")
  end

  def contact_gp?
    session[:nhs_letter] != I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
  end
end
