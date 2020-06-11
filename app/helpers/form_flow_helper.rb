# typed: false
module FormFlowHelper
  FIRST_QUESTION = "live_in_england".freeze

  def check_first_question
    redirect_to_first_question unless first_question_answered?
  end

  def redirect_to_first_question
    redirect_to controller: "coronavirus_form/#{FIRST_QUESTION}", action: "show"
  end

  def first_question_path
    FIRST_QUESTION.dasherize
  end

private

  def first_question_answered?
    session[FIRST_QUESTION.to_sym].present?
  end
end
