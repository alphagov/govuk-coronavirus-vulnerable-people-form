# typed: strict
# frozen_string_literal: true

class CoronavirusForm::LiveInEnglandController < ApplicationController
  extend T::Sig
  class SubmitParams < T::Struct
    const :live_in_england, T.nilable(String)
  end

  skip_before_action :check_first_question

  sig { returns CoronavirusForm::LiveInEnglandController }
  def initialize
    @form_responses = T.let( {}, T::Hash[Symbol, String])
    super
  end

  sig { void }
  def submit
    typed_params = TypedParams[SubmitParams].new.extract!(params)
    @form_responses = {
      live_in_england: strip_tags(typed_params.live_in_england).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:live_in_england],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif @form_responses[:live_in_england] == I18n.t("coronavirus_form.questions.live_in_england.options.option_no.label")
      session[:live_in_england] = @form_responses[:live_in_england]
      redirect_to not_eligible_england_url
    elsif session[:check_answers_seen]
      session[:live_in_england] = @form_responses[:live_in_england]
      redirect_to check_your_answers_url
    else
      session[:live_in_england] = @form_responses[:live_in_england]
      redirect_to nhs_letter_url
    end
  end

private

  sig { returns String }
  def previous_path
    "/"
  end
end
