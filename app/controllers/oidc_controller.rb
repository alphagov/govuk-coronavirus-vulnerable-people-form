# frozen_string_literal: true

class OidcController < ApplicationController
  def callback
    reset_session
    pp request.env["omniauth.auth"].to_h
    nhs_number = request.env["omniauth.auth"].info["nhs_number"]
    if nhs_number
      session[:know_nhs_number] = t("coronavirus_form.questions.know_nhs_number.options.option_yes")
      session[:nhs_number] = request.env["omniauth.auth"].info["nhs_number"]
    end
    session[:email] = request.env["omniauth.auth"].info["email"]
    session[:phone_number_calls] = request.env["omniauth.auth"].info["phone_number"]
    session[:phone_number_texts] = request.env["omniauth.auth"].info["phone_number"]
    session[:date_of_birth] = request.env["omniauth.auth"].info["birthdate"]
    redirect_to live_in_england_path
  end

  def failure; end

  def logout
    reset_session
    redirect_to root_path
  end
end
