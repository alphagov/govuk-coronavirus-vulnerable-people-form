# frozen_string_literal: true

class CoronavirusForm::OfferFoodController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    offer_food = sanitize(params[:offer_food]).presence
    session[:offer_food] = offer_food

    invalid_fields = validate_radio_field(
      PAGE,
      radio: offer_food,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "coronavirus_form/#{PAGE}"
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/offer_transport", action: "show"
    end
  end

private

  PAGE = "offer_food"

  def previous_path
    coronavirus_form_do_you_have_offer_food_to_offer_path
  end
end
