# frozen_string_literal: true

class CoronavirusForm::NotEligibleEnglandController < ApplicationController
  def show
    render "coronavirus_form/not_eligible_england"
  end

private

  def previous_path
    live_in_england_path
  end
end
