# typed: true
# frozen_string_literal: true

class CoronavirusForm::CookiesController < ApplicationController
  skip_before_action :check_first_question

  def show
    @previous_page = return_path
    super
  end

private

  def return_path
    return first_question_path if session[:previous_path].blank?

    path = URI(session[:previous_path]).path
    path.presence || first_question_path
  end
end
