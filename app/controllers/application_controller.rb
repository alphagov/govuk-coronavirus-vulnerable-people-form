# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  before_action :check_first_question, only: [:show]

  def show; end

  if ENV["REQUIRE_BASIC_AUTH"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

private

  helper_method :previous_path

  def previous_path
    raise NotImplementedError, "Define a previous path"
  end

  def log_validation_error(invalid_fields)
    logger.info "validation error - #{invalid_fields.pluck(:text).to_sentence}"
  end

  def check_first_question
    if session[:live_in_england].blank?
      redirect_to controller: "coronavirus_form/live_in_england", action: "show"
    end
  end
end
