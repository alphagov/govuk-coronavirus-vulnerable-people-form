# frozen_string_literal: true

class CoronavirusForm::CarrySuppliesController < ApplicationController
  def submit
    carry_supplies = sanitize(params[:carry_supplies]).presence
    session[:carry_supplies] = carry_supplies

    invalid_fields = validate_radio_field(
      controller_name,
      radio: carry_supplies,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    else
      redirect_to check_your_answers_url
    end
  end

private

  def previous_path
    dietary_requirements_path
  end
end
