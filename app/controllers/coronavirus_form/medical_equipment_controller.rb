# frozen_string_literal: true

class CoronavirusForm::MedicalEquipmentController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    medical_equipment = sanitize(params[:medical_equipment]).presence

    session[:medical_equipment] = medical_equipment

    invalid_fields = validate_radio_field(
      PAGE,
      radio: medical_equipment,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: 'show'
    elsif session[:medical_equipment] == I18n.t("coronavirus_form.medical_equipment.options.option_yes.label")
      redirect_to controller: "coronavirus_form/medical_equipment_type", action: 'show'
    else
      redirect_to controller: "coronavirus_form/hotel_rooms", action: 'show'
    end
  end

  private

  PAGE = "medical_equipment"

  def previous_path
    "/"
  end
end
