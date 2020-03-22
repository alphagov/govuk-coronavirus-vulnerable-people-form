# frozen_string_literal: true

class CoronavirusForm::SupportAddressController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  REQUIRED_FIELDS = %w(
      building_and_street_line_1
      town_city
  ).freeze

  def show
    session[:support_address] ||= {}
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session[:support_address] ||= {}
    session[:support_address]["building_and_street_line_1"] = sanitize(params[:building_and_street_line_1]).presence
    session[:support_address]["building_and_street_line_2"] = sanitize(params[:building_and_street_line_2]).presence
    session[:support_address]["town_city"] = sanitize(params[:town_city]).presence
    session[:support_address]["county"] = sanitize(params[:county]).presence
    session[:support_address]["postcode"] = sanitize(params[:postcode]).presence

    invalid_fields = validate_fields(session[:support_address])

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "support_address"
  NEXT_PAGE = "contact_details"

  def validate_fields(support_address)
    [
      validate_missing_fields(support_address),
      validate_conditionally_present_fields(support_address),
    ].flatten.uniq
  end

  def validate_conditionally_present_fields(product)
    return [] if product["postcode"].present? || product["county"].present?

    invalid_fields = []

    if product["county"].blank?
      invalid_fields << {
        field: "county",
        text: t("coronavirus_form.errors.missing_county_or_postcode_field"),
      }
    elsif product["postcode"].blank?
      invalid_fields << {
        field: "postcode",
        text: t("coronavirus_form.errors.missing_county_or_postcode_field"),
      }
    end

    invalid_fields
  end

  def validate_missing_fields(product)
    REQUIRED_FIELDS.each_with_object([]) do |field, invalid_fields|
      next if product[field].present?

      invalid_fields << {
        field: field.to_s,
        text: t("coronavirus_form.questions.#{PAGE}.#{field}.custom_error",
                default: t("coronavirus_form.errors.missing_mandatory_text_field",
                           field: t("coronavirus_form.questions.#{PAGE}.#{field}.label")).humanize),
      }
    end
  end

  def previous_path
    coronavirus_form_name_path
  end
end
