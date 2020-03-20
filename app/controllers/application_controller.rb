# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  helper_method :previous_path

  def has_seen_check_answers?
    session[:check_answers_seen]
  end

  def previous_path
    raise NotImplementedError, 'Define a previous path'
  end
end
