# frozen_string_literal: true

class CoronavirusForm::AddressLookupController < ApplicationController
  def show
    @addresses = helpers.postcode_lookup(session[:postcode])
    render controller_path, status: :ok
  rescue AddressLookupError, AddressNotFoundError => e
    session[:flash] = e.message
    redirect_to postcode_lookup_url
  end

  def submit
    if session[:check_answers_seen]
      redirect_to check_your_answers_url
    else
      address = helpers.uprn_lookup(params[:uprn]).dig("results", 0, "LPI")
      session[:support_address] = helpers.convert_address(address)
      redirect_to support_address_path
    end
  end

private

  def previous_path
    postcode_lookup_path
  end
end
