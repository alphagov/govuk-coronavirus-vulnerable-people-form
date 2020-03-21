# frozen_string_literal: true

class CoronavirusForm::NotEligibleSuppliesController < ApplicationController
  def show
    render "coronavirus_form/not_eligible_supplies"
  end
end
