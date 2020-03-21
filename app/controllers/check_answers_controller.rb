# frozen_string_literal: true

class CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    session[:check_answers_seen] = true
    render "check_answers"
  end
end
