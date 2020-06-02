# frozen_string_literal: true

class CoronavirusForm::AddressLookupController < ApplicationController
  def show
    @addresses = helpers.postcode_lookup(session[:postcode])
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

    address = JSON.parse(params[:address]).to_h
    session[:support_address] = helpers.convert_address(address)
    session.delete(:postcode)
    redirect_to support_address_path
  rescue JSON::ParserError, AddressNotProvidedError
    render controller_path, status: :unprocessable_entity
  end

private

  def previous_path
    postcode_lookup_path
  end
end
