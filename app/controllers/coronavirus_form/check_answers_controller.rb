# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  include AnswersHelper

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

    unless smoke_tester? || preview_app?
      FormResponse.create(
        ReferenceId: submission_reference,
        UnixTimestamp: Time.zone.now,
        FormResponse: session,
      )
    end

    reset_session

    redirect_to confirmation_url(reference_number: submission_reference)
  end

private

  def smoke_tester?
    email = session.dig(:contact_details, :email)
    email.present? && email == Rails.application.config.courtesy_copy_email
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end
end
