# frozen_string_literal: true

class CoronavirusForm::AdditionalProductCheckController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    additional_product_check = sanitize(params[:additional_product_check]).presence

    invalid_fields = validate_radio_field(
      PAGE,
      radio: additional_product_check,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    elsif additional_product_check == I18n.t("coronavirus_form.additional_product_check.options.option_yes.label")
      redirect_to controller: "coronavirus_form/product_details", action: "show"
    else
      # TODO: This should go to the next view
      redirect_to controller: "coronavirus_form/thank_you", action: "show"
    end
  end

private

  PAGE = "additional_product_check"

  def previous_path
    session[:products] ||= []
    latest_product_id = (session[:products].last || {}).dig("product_id")
    "/coronavirus-form/product-details?product_id=#{latest_product_id}"
  end
end
