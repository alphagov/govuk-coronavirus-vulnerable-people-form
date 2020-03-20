# frozen_string_literal: true

class CoronavirusForm::HotelRoomsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    # medical_equipment = sanitize(params[:medical_equipment]).presence
    #
    # session[:medical_equipment] = medical_equipment
    #
    # puts medical_equipment
    # invalid_fields = validate_radio_field(
    #   PAGE,
    #   radio: medical_equipment,
    #   allowed_values: I18n.t("coronavirus_form.#{PAGE}.options").map { |_, item| item.dig(:label) }
    # )
    #
    # if invalid_fields.any?
    #   flash.now[:validation] = invalid_fields
    #   render "coronavirus_form/#{PAGE}"
    # elsif has_seen_check_answers?
    #   redirect_to controller: 'coronavirus_form/check_answers'
    # else
    #   controller = medical_equipment == "yes" ? "coronavirus_form/medical_equipment_kind" : "coronavirus_form/hotel_rooms"
    #   redirect_to controller: controller, action: 'show'
    # end
  end

  private

  PAGE = 'hotel_rooms'

  def previous_path
    '/'
  end
end
