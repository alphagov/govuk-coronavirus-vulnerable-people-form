# typed: false
# frozen_string_literal: true

class CoronavirusForm::NotEligibleEnglandController < ApplicationController
private

  def previous_path
    live_in_england_path
  end
end
