# frozen_string_literal: true

class CoronavirusForm::CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    session[:check_answers_seen] = true
    render 'coronavirus_form/check_answers'
  end
end
