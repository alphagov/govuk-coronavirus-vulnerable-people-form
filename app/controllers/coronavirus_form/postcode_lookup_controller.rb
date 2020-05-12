# frozen_string_literal: true

class CoronavirusForm::PostcodeLookupController < ApplicationController
  def show
    if session[:flash].present?
      flash.now[:validation] = [{ text: session[:flash], field: "postcode" }]
      session.delete(:flash)
      @postcode_entered = true
      render controller_path, status: :unprocessable_entity
    else
      render controller_path, status: :ok
    end
  end

  def submit
    redirect_to check_your_answers_url if session[:check_answers_seen]

    if params[:postcode].blank?
      flash.now[:validation] = [{ text: I18n.t("coronavirus_form.questions.postcode_entry.title"), field: "postcode" }]
      render controller_path, status: :unprocessable_entity
    else
      errors = helpers.validate_postcode("postcode", params[:postcode])

      if errors.any?
        flash.now[:validation] = errors
        render controller_path, status: :unprocessable_entity
      else
        session[:postcode] = params[:postcode]
        redirect_to address_lookup_path
      end
    end
  end

private

  def previous_path
    date_of_birth_path
  end
end
