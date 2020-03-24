module AnswersHelper
  def answer_items
    questions.map do |question|
      answer = concat_answer(session[question], question)

      {
        field: t("coronavirus_form.questions.#{question}.title"),
        value: sanitize(answer),
        edit: {
          href: "#{question.dasherize}?change-answer",
        },
      }
    end
  end

  def concat_answer(answer, question)
    return answer unless answer.is_a?(Hash)

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
    questions ||= YAML.load_file(Rails.root.join("config/locales/en.yml"))
    questions["en"]["coronavirus_form"]["questions"].keys
  end
end
