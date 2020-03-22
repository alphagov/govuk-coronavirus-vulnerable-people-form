# frozen_string_literal: true

class CoronavirusForm::NameController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session["name"] ||= {}
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    session["name"] ||= {}
    session["name"]["first_name"] = sanitize(params[:first_name]).presence
    session["name"]["middle_name"] = sanitize(params[:middle_name]).presence
    session["name"]["last_name"] = sanitize(params[:last_name]).presence

    invalid_fields = validate_text_fields(%w[first_name last_name], "name")

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

  PAGE = "name"
  NEXT_PAGE = "start" # TODO change to address

  def validate_text_fields(mandatory_fields, page)
    mandatory_fields.each_with_object([]) do |field, invalid_fields|
      next if session["name"][field].present?

      invalid_fields << { field: field.to_s,
                          text: t("coronavirus_form.questions.#{page}.#{field}.custom_error",
                                  default: t("coronavirus_form.errors.missing_mandatory_text_field", field: t("coronavirus_form.questions.#{page}.#{field}.label")).humanize) }
    end
  end

  def previous_path
    "/" # TODO
  end
end
