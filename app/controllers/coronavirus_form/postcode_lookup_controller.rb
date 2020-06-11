# typed: false
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
    if params[:postcode].blank?
      flash.now[:validation] = [{ text: I18n.t("coronavirus_form.questions.postcode_lookup.title"), field: "postcode" }]
      render controller_path, status: :unprocessable_entity
    else
      errors = helpers.validate_postcode("postcode", params[:postcode])

      if errors.any?
        flash.now[:validation] = errors
        render controller_path, status: :unprocessable_entity
      else
        session[:support_address] ||= {}
        session[:support_address]["postcode"] = strip_tags(params[:postcode]&.gsub(/[[:space:]]+/, "")).presence
        redirect_to address_lookup_path
      end
    end
  end

private

  def previous_path
    date_of_birth_path
  end
end
