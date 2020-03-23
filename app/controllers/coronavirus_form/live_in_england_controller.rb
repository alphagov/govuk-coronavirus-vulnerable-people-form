# frozen_string_literal: true

class CoronavirusForm::LiveInEnglandController < ApplicationController
  skip_before_action :check_first_question

  def submit
    live_in_england = strip_tags(params[:live_in_england]).presence
    session[:live_in_england] = live_in_england

    invalid_fields = validate_radio_field(
      controller_name,
      radio: live_in_england,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:live_in_england] == I18n.t("coronavirus_form.questions.live_in_england.options.option_no.label")
      redirect_to not_eligible_england_url
    elsif session[:check_answers_seen]
      redirect_to check_your_answers_url
    else
      redirect_to nhs_letter_url
    end
  end

private

  def previous_path
    "/"
  end
end
