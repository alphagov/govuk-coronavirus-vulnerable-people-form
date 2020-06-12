# frozen_string_literal: true

class CoronavirusForm::SupportAddressController < ApplicationController
  REQUIRED_FIELDS = %w[
    building_and_street_line_1
    town_city
    postcode
  ].freeze

  before_action :set_default_support_address

  def show
    @form_responses = session.to_hash.with_indifferent_access

    if session[:flash].present?
      flash.now[:validation] = [{ text: session[:flash], field: "" }]
      session.delete(:flash)
      render controller_path, status: :ok
    else
      respond_to do |format|
        format.html { render controller_path }
      end
    end
  end

  def submit
    invalid_fields = validate_fields

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      @form_responses = { support_address: given_address }

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    else
      @form_responses = helpers.update_support_address(session[:support_address]&.symbolize_keys, given_address)

      session[:support_address] = @form_responses[:support_address]

      if session[:check_answers_seen]
        redirect_to check_your_answers_url
      else
        redirect_to contact_details_url
      end
    end
  end

private

  def set_default_support_address
    session[:support_address] ||= {}
  end

  def given_address
    {
      building_and_street_line_1: strip_tags_from_address_field(params[:building_and_street_line_1]),
      building_and_street_line_2: strip_tags_from_address_field(params[:building_and_street_line_2]),
      town_city: strip_tags_from_address_field(params[:town_city]),
      county: strip_tags_from_address_field(params[:county]),
      postcode: strip_tags_from_postcode_field(params[:postcode]),
    }
  end

  def strip_tags_from_address_field(param)
    param.nil? ? "" : strip_tags(param&.strip).presence
  end

  def strip_tags_from_postcode_field(postcode)
    postcode.nil? ? "" : strip_tags(postcode&.gsub(/[[:space:]]+/, "")).presence
  end

  def validate_fields
    [
      validate_missing_fields,
      validate_postcode("postcode", params.dig("postcode")),
    ].flatten.uniq
  end

  def validate_missing_fields
    REQUIRED_FIELDS.each_with_object([]) do |field, invalid_fields|
      next if params.dig(field).present?

      invalid_fields << {
        field: field.to_s,
        text: t(
          "coronavirus_form.questions.#{controller_name}.#{field}.custom_error",
          default: t(
            "coronavirus_form.errors.missing_mandatory_text_field",
            field: t("coronavirus_form.questions.#{controller_name}.#{field}.label"),
          ).humanize,
        ),
      }
    end
  end

  def previous_path
    address_lookup_path
  end
end
