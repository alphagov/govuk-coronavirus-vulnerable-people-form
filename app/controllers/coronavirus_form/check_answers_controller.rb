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

    validation_errors = validate_against_form_response_schema(sanitised_session)
    if validation_errors.any?
      GovukError.notify(
        FormResponseInvalidError.new,
        extra: { validation_errors: validation_errors },
      )
    end

    unless smoke_tester? || preview_app?
      FormResponse.create(
        ReferenceId: submission_reference,
        UnixTimestamp: Time.zone.now,
        FormResponse: sanitised_session,
      )

      send_confirmation_email if session_with_indifferent_access.dig(:contact_details, :email).present?
      send_confirmation_sms if session_with_indifferent_access.dig(:contact_details, :phone_number_texts).present? && mobile_number_provided?
    end

    reset_session

    redirect_to confirmation_url(reference_number: submission_reference, contact_gp: @contact_gp)
  end

  EXCLUDED_FIELDS = %i[session_id _csrf_token current_path previous_path check_answers_seen postcode].freeze

private

  def smoke_tester?
    email = session_with_indifferent_access.dig(:contact_details, :email)
    mobile_number = session_with_indifferent_access.dig(:contact_details, :phone_number_texts)
    (email.present? && email == Rails.application.config.courtesy_copy_email) || (mobile_number.present? && mobile_number == Rails.application.config.test_telephone_number)
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end

  def send_confirmation_email
    mailer = CoronavirusFormMailer.with(
      first_name: session_with_indifferent_access.dig(:name, :first_name),
      last_name: session_with_indifferent_access.dig(:name, :last_name),
      reference_number: reference_number,
      contact_gp: @contact_gp,
    )
    mailer.confirmation_email(user_email).deliver_later
  end

  def send_confirmation_sms
    mailer = CoronavirusFormMailer.with(
      first_name: session_with_indifferent_access.dig(:name, :first_name),
      last_name: session_with_indifferent_access.dig(:name, :last_name),
      reference_number: reference_number,
      contact_gp: @contact_gp,
    )
    mailer.confirmation_sms(user_mobile_number).deliver_later
  end

  def user_email
    if ENV["PAAS_ENV"] == "staging"
      Rails.application.config.courtesy_copy_email
    else
      session_with_indifferent_access.dig(:contact_details, :email)
    end
  end

  def user_mobile_number
    TelephoneNumber.parse(session_with_indifferent_access.dig(:contact_details, :phone_number_texts), :gb).national_number(formatted: false)
  end

  def mobile_number_provided?
    TelephoneNumber.valid?(session_with_indifferent_access.dig(:contact_details, :phone_number_texts), :gb, [:mobile])
  end

  def session_with_indifferent_access
    session.to_h.with_indifferent_access
  end

  def sanitised_session
    session_with_indifferent_access.except(*EXCLUDED_FIELDS)
  end

  def contact_gp?
    session[:nhs_letter] != I18n.t("coronavirus_form.questions.nhs_letter.options.option_yes.label")
  end
end
