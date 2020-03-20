# frozen_string_literal: true

class CoronavirusForm::WhichServicesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session[:which_services] ||= []
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    which_services = Array(params[:which_services]).map { |item| sanitize(item).presence }.compact

    session[:which_services] = which_services

    invalid_fields = validate_checkbox_field(
      PAGE,
      values: which_services,
      allowed_values: I18n.t("coronavirus_form.#{PAGE}.options").map { |_, item| item.dig(:label) },
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    else
      redirect_to controller: session["check_answers_seen"] ? "coronavirus_form/check_answers" : "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "which_services".freeze
  NEXT_PAGE = "thank_you".freeze

  def previous_path
    "/coronavirus-form/which-goods"
  end
end
