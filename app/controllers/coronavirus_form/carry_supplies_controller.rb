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
      redirect_to check_your_answers_path
    else
      redirect_to check_your_answers_path
    end
  end

private

  PAGE = "carry_supplies"

  def previous_path
    dietary_requirements_path
  end
end
