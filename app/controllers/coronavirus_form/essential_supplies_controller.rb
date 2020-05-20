# frozen_string_literal: true

class CoronavirusForm::EssentialSuppliesController < ApplicationController
  def submit
    @form_responses = {
      essential_supplies: strip_tags(params[:essential_supplies]).presence,
    }

    invalid_fields = validate_radio_field(
      controller_name,
      radio: @form_responses[:essential_supplies],
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    else
      update_session_store
      redirect_to next_page_url
    end
  end

private

  def update_session_store
    session[:essential_supplies] = @form_responses[:essential_supplies]
    if @form_responses[:essential_supplies] == I18n.t("coronavirus_form.questions.essential_supplies.options.option_yes.label")
      session[:dietary_requirements] = nil
      session[:carry_supplies] = nil
    end
  end

  def next_page_url
    return dietary_requirements_url if answer_next_question?
    return check_your_answers_url if session[:check_answers_seen]

    basic_care_needs_url
  end

  def answer_next_question?
    @form_responses[:essential_supplies] == I18n.t("coronavirus_form.questions.essential_supplies.options.option_no.label") &&
      (session[:dietary_requirements].blank? || session[:carry_supplies].blank?)
  end

  def previous_path
    nhs_number_path
  end
end
