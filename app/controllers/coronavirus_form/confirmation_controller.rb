# frozen_string_literal: true

class CoronavirusForm::ConfirmationController < ApplicationController
  skip_before_action :check_first_question

  def show
    render "coronavirus_form/confirmation"
  end
end
