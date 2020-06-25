# frozen_string_literal: true

class OidcController < ApplicationController
  def callback
    nhs_number = request.env["omniauth.auth"].info["nhs_number"]
    if nhs_number
      session[:know_nhs_number] = t("coronavirus_form.questions.know_nhs_number.options.option_yes.label")
      session[:nhs_number] = request.env["omniauth.auth"].info["nhs_number"]
    end
    session[:name] = { last_name: request.env["omniauth.auth"].info["surname"] }
    session[:contact_details] = {
      phone_number_calls: request.env["omniauth.auth"].info["phone_number"],
      phone_number_texts: request.env["omniauth.auth"].info["phone_number"],
      email: request.env["omniauth.auth"].info["email"],
    }
    birthdate_string = request.env["omniauth.auth"].info["date_of_birth"]
    if birthdate_string
      birthdate = Date.parse(birthdate_string)
      session[:date_of_birth] = {
        year: birthdate.year,
        day: birthdate.day,
        month: birthdate.month,
      }
    end
    redirect_to live_in_england_path
  end

  def failure; end

  def logout
    reset_session
    redirect_to root_path
  end
end
