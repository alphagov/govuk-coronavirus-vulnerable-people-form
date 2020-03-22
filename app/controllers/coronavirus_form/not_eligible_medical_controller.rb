# frozen_string_literal: true

class CoronavirusForm::NotEligibleMedicalController < ApplicationController
  def show
    render "coronavirus_form/not_eligible_medical"
  end

private

  def previous_path
    medical_conditions_path
  end
end
