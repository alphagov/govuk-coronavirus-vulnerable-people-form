# frozen_string_literal: true

class CoronavirusForm::PeopleToTalkToController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    people_to_talk_to = sanitize(params[:people_to_talk_to]).presence
    session[:people_to_talk_to] = people_to_talk_to

    invalid_fields = validate_radio_field(
      PAGE,
      radio: people_to_talk_to,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "people_to_talk_to"
  NEXT_PAGE = "dietary_requirements"

  def previous_path
    coronavirus_form_basic_care_needs_path
  end
end
