# frozen_string_literal: true

class CoronavirusForm::LiveInEnglandController < ApplicationController
  skip_before_action :check_first_question

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    live_in_england = sanitize(params[:live_in_england]).presence
    session[:live_in_england] = live_in_england

    invalid_fields = validate_radio_field(
      PAGE,
      radio: live_in_england,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session[:live_in_england] == I18n.t("coronavirus_form.questions.live_in_england.options.option_no.label")
      redirect_to controller: "coronavirus_form/not_eligible_england", action: "show"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "live_in_england"
  NEXT_PAGE = "nhs_letter"

  def previous_path
    "/"
  end
end
