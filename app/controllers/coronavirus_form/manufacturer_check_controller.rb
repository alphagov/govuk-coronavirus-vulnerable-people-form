# frozen_string_literal: true

class CoronavirusForm::ManufacturerCheckController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session[:manufacturer_check] = []
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    manufacturer_check = Array(params[:manufacturer_check]).map { |item| sanitize(item).presence }.compact

    session[:manufacturer_check] = manufacturer_check

    invalid_fields = validate_checkbox_field(
      PAGE,
      values: manufacturer_check,
      allowed_values: I18n.t("coronavirus_form.#{PAGE}.options").map { |_, item| item.dig(:label) },
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/product_details", action: "show"
    end
  end

private

  PAGE = "manufacturer_check"

  def previous_path
    "/coronavirus-form/medical-equipment-type"
  end
end
