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

    # TODO: remove this once data export has been updated to allow new answers to medical conditions question
    if session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_medical.label") ||
        session[:medical_conditions] == I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_gp.label")
      session[:medical_conditions] = "Yes, I have one of the medical conditions on the list"
    end

    session[:reference_id] = submission_reference

    validation_errors = validate_against_form_response_schema(session.to_h)
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
        FormResponse: session,
      )

      send_confirmation_email if session_with_indifferent_access.dig(:contact_details, :email).present?
    end

    reset_session

    redirect_to confirmation_url(reference_number: submission_reference)
  end

private

  def smoke_tester?
    email = session_with_indifferent_access.dig(:contact_details, :email)
    email.present? && email == Rails.application.config.courtesy_copy_email
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
    )
    mailer.confirmation_email(user_email).deliver_later
  end

  def user_email
    if ENV["PAAS_ENV"] == "staging"
      Rails.application.config.courtesy_copy_email
    else
      session_with_indifferent_access.dig(:contact_details, :email)
    end
  end

  def session_with_indifferent_access
    session.to_h.with_indifferent_access
  end
end
