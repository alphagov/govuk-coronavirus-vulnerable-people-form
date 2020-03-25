# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  def show
    @items = items
    session[:check_answers_seen] = true
    render "coronavirus_form/check_answers"
  end

  def submit
    submission_reference = reference_number

    session[:reference_id] = submission_reference

    FormResponse.create(
      ReferenceId: submission_reference,
      UnixTimestamp: Time.zone.now,
      FormResponse: session,
    )

    reset_session

    redirect_to controller: "coronavirus_form/confirmation", action: "show", reference_number: submission_reference
  end

private

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end

  def items
    questions.map do |question|
      # We have answers as strings and hashes. The hashes need a little more
      # work to make them readable.
      value = session[question].is_a?(Hash) ? concat_answer(session[question], question) : session[question]

      {
        field: t("coronavirus_form.questions.#{question}.title"),
        value: sanitize(value),
        edit: {
          href: "#{question.dasherize}?change-answer",
        },
      }
    end
  end

  def concat_answer(answer, question)
    concatenated_answer = []
    joiner = " "

    if question.eql?("contact_details")
      concatenated_answer << "Phone number: #{answer['phone_number_calls']}" if answer["phone_number_calls"]
      concatenated_answer << "Text: #{answer['phone_number_texts']}" if answer["phone_number_texts"]
      concatenated_answer << "Email: #{answer['email']}" if answer["email"]
      joiner = "<br>"
    elsif question.eql?("support_address")
      concatenated_answer = answer.values.compact
      joiner = ",<br>"
    elsif question.eql?("date_of_birth")
      concatenated_answer = answer.values.compact
      joiner = "/"
    else
      concatenated_answer = answer.values.compact
    end

    concatenated_answer.join(joiner)
  end

  def questions
    @questions ||= YAML.load_file(Rails.root.join("config/locales/en.yml"))
    @questions["en"]["coronavirus_form"]["questions"].keys
  end
end
