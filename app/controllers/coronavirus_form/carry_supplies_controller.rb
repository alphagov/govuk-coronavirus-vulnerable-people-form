# frozen_string_literal: true

class CoronavirusForm::CarrySuppliesController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    carry_supplies = sanitize(params[:carry_supplies]).presence
    session[:carry_supplies] = carry_supplies

    invalid_fields = validate_radio_field(
      PAGE,
      radio: carry_supplies,
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

  PAGE = "carry_supplies"
  NEXT_PAGE = "check_answers"

  def previous_path
    dietary_requirements_path
  end
end
