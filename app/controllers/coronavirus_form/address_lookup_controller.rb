# typed: false
# frozen_string_literal: true

class CoronavirusForm::AddressLookupController < ApplicationController
  def show
    @addresses = helpers.postcode_lookup(session.to_h.with_indifferent_access.dig(:support_address, :postcode))
    render controller_path, status: :ok
  rescue AddressAuthError => e
    session[:flash] = e.message
    GovukError.notify("API Key is invalid!")
    redirect_to support_address_path
  rescue AddressLookupError, AddressNotFoundError => e
    session[:flash] = e.message
    redirect_to postcode_lookup_url
  end

  def submit
    raise AddressNotProvidedError if params[:address].blank?

    address = helpers.remove_changes_to_ordnance_survey_api_response(params[:address])
    session[:support_address] = helpers.convert_address(address)
    redirect_to support_address_path
  rescue JSON::ParserError, AddressNotProvidedError
    render controller_path, status: :unprocessable_entity
  end

private

  def previous_path
    postcode_lookup_path
  end
end
