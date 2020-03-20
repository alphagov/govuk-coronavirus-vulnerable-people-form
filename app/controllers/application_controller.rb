# frozen_string_literal: true

class ApplicationController < ActionController::Base

  if ENV["REQUIRE_BASIC_AUTH"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

  private

  helper_method :previous_path

  def previous_path
    raise NotImplementedError, 'Define a previous path'
  end
end
