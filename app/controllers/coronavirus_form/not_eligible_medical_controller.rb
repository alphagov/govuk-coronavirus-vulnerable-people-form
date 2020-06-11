# typed: false
# frozen_string_literal: true

class CoronavirusForm::NotEligibleMedicalController < ApplicationController
private

  def previous_path
    medical_conditions_path
  end
end
