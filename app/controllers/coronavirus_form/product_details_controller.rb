# frozen_string_literal: true

class CoronavirusForm::ProductDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  REQUIRED_FIELDS = %w(product_name product_cost certification_details product_postcode lead_time).freeze

  def show
    session[:products] ||= []
    @product = find_product(params["product_id"], session[:products])
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    @product = sanitized_product(params)
    add_product_to_session(@product)

    invalid_fields = validate_fields(@product)

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    else
      redirect_to controller: session["check_answers_seen"] ? "coronavirus_form/check_answers" : "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  NEXT_PAGE = "additional_product_check"
  PAGE = "product_details"

  def find_product(product_id, products)
    products.find { |product| product["product_id"] == product_id } || {}
  end

  def validate_fields(product)
    missing_fields = validate_missing_fields(product)
    postcode_validation = validate_postcode("product_postcode", product["product_postcode"])
    missing_fields + postcode_validation
  end

  def validate_missing_fields(product)
    REQUIRED_FIELDS.each_with_object([]) do |field, invalid_fields|
      next if product[field].present?

      invalid_fields << {
        field: field.to_s,
        text: t("coronavirus_form.#{PAGE}.#{field}.custom_error",
                default: t("coronavirus_form.errors.missing_mandatory_text_field",
                           field: t("coronavirus_form.#{PAGE}.#{field}.label")).humanize),
      }
    end
  end

  def sanitized_product(params)
    {
      "product_id" => sanitize(params[:product_id]).presence || SecureRandom.uuid,
      "product_name" => sanitize(params[:product_name]).presence,
      "product_cost" => sanitize(params[:product_cost]).presence,
      "certification_details" => sanitize(params[:certification_details]).presence,
      "product_postcode" => sanitize(params[:product_postcode]).presence,
      "product_url" => sanitize(params[:product_url]).presence,
      "lead_time" => sanitize(params[:lead_time]).presence,
    }
  end

  def add_product_to_session(product)
    session[:products] ||= []
    products = session[:products].reject do |prod|
      prod["product_id"] == product["product_id"]
    end
    session[:products] = products << @product
  end

  def previous_path
    return coronavirus_form_additional_product_path if params["product_id"]

    return coronavirus_form_check_your_answers_path if session["check_answers_seen"]

    coronavirus_form_are_you_a_manufacturer_path
  end
end
