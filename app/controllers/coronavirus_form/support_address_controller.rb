# frozen_string_literal: true

class CoronavirusForm::SupportAddressController < ApplicationController
  REQUIRED_FIELDS = %i[
      building_and_street_line_1
      town_city
      postcode
  ].freeze

  def submit
    @form_responses = {
      support_address: {
        building_and_street_line_1: strip_tags(params[:building_and_street_line_1]&.strip).presence,
        building_and_street_line_2: strip_tags(params[:building_and_street_line_2]&.strip).presence,
        town_city: strip_tags(params[:town_city]&.strip).presence,
        county: strip_tags(params[:county]&.strip).presence,
        postcode: strip_tags(params[:postcode]&.strip).presence,
      },
    }

    invalid_fields = validate_fields

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)

      respond_to do |format|
        format.html { render controller_path, status: :unprocessable_entity }
      end
    elsif session[:check_answers_seen]
      session[:support_address] = @form_responses[:support_address]
      redirect_to check_your_answers_url
    else
      session[:support_address] = @form_responses[:support_address]
      redirect_to contact_details_url
    end
  end

private

  def validate_fields
    [
      validate_missing_fields,
      validate_postcode("postcode", @form_responses[:support_address].dig(:postcode)),
    ].flatten.uniq
  end

  def validate_missing_fields
    REQUIRED_FIELDS.each_with_object([]) do |field, invalid_fields|
      next if @form_responses[:support_address].dig(field).present?

      invalid_fields << {
        field: field.to_s,
        text: t("coronavirus_form.questions.#{controller_name}.#{field}.custom_error",
                default: t("coronavirus_form.errors.missing_mandatory_text_field",
                           field: t("coronavirus_form.questions.#{controller_name}.#{field}.label")).humanize),
      }
    end
  end

  def previous_path
    date_of_birth_path
  end
end
