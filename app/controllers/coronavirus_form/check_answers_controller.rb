# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    if session[:nhs_letter].present?
      @items = items
      session[:check_answers_seen] = true
      render "coronavirus_form/check_answers"
    else
      redirect_to controller: "coronavirus_form/start", action: "show"
    end
  end

  def submit
    submission_reference = reference_number

    session[:reference_number] = submission_reference
    FormResponse.create(form_response: session)

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
      value = session[question].is_a?(Hash) ? concat_answer(session[question]) : session[question]

      {
        field: t("coronavirus_form.questions.#{question}.title"),
        value: value,
        edit: {
          href: question.dasherize,
        },
      }
    end
  end

  def concat_answer(answer)
    answer.values.compact.join(" ")
  end

  def questions
    @questions ||= YAML.load_file(Rails.root.join("config/locales/en.yml"))
    @questions["en"]["coronavirus_form"]["questions"].keys
  end
end
