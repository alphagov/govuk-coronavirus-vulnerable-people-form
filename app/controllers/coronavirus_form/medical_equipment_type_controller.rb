# frozen_string_literal: true

class CoronavirusForm::MedicalEquipmentTypeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    session[:medical_equipment_type] ||= []
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    medical_equipment_type = Array(params[:medical_equipment_type]).map { |item| sanitize(item).presence }.compact
    medical_equipment_type_other = sanitize(params[:medical_equipment_type_other]).presence
    session[:medical_equipment_type] = medical_equipment_type
    session[:medical_equipment_type_other] = if selected_other?(medical_equipment_type)
                                               medical_equipment_type_other
                                             else
                                               ""
                                             end
    invalid_fields = validate_checkbox_field(
      PAGE,
      values: medical_equipment_type,
      allowed_values: I18n.t("coronavirus_form.#{PAGE}.options").map { |_, item| item.dig(:label) },
      other: medical_equipment_type_other,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    else
      redirect_to controller: session["check_answers_seen"] ? "coronavirus_form/check_answers" : "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "medical_equipment_type"
  NEXT_PAGE = "manufacturer_check"

  def selected_other?(medical_equipment_type)
    medical_equipment_type.include?(
      I18n.t("coronavirus_form.medical_equipment_type.options.other.label"),
    )
  end

  def previous_path
    "/coronavirus-form/medical-equipment"
  end
end
