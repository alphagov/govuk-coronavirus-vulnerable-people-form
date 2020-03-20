# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  helper_method :previous_path

  def previous_path
    raise NotImplementedError, 'Define a previous path'
  end
end
