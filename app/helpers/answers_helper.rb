module AnswersHelper
  def answer_items
    answers = questions.map do |question|
      answer = concat_answer(session[question], question)

      unless skip_question?(question, answer)
        {
          field: t("coronavirus_form.questions.#{question}.title"),
          value: sanitize(answer),
          edit: {
            href: "#{question.dasherize}?change-answer",
          },
        }
      end
    end

    answers.compact
  end

  def skip_question?(question, answer)
    question == "nhs_number" && answer.nil?
  end

  def concat_answer(answer, question)
    return answer unless answer.is_a?(Hash)

    if question.eql?("contact_details")
      concatenated_answer = []
      concatenated_answer << "Phone number: #{answer['phone_number_calls']}" if answer["phone_number_calls"]
      concatenated_answer << "Text: #{answer['phone_number_texts']}" if answer["phone_number_texts"]
      concatenated_answer << "Email: #{answer['email']}" if answer["email"]
      concatenated_answer.join("<br>")
    elsif question.eql?("support_address")
      answer.values.compact.join(",<br>")
    elsif question.eql?("date_of_birth")
      Time.zone.local(answer["year"], answer["month"], answer["day"]).strftime("%d/%m/%Y") if answer.present?
    else
      answer.values.compact.join(" ")
    end
  end

  def questions
    questions ||= YAML.load_file(Rails.root.join("config/locales/en.yml"))
    questions["en"]["coronavirus_form"]["questions"].keys
  end
end
