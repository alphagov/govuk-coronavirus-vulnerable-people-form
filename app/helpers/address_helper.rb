# frozen_string_literal: true

module AddressHelper
  API_URL = "https://api.ordnancesurvey.co.uk/places/v1/addresses/postcode?dataset=LPI"

  def postcode_lookup(postcode)
    postcode_url = "#{API_URL}&postcode=#{postcode}&key=#{ENV['ORDNANCE_SURVEY_PLACES_API_KEY']}"

    response = Faraday.get(postcode_url)
    details = JSON.parse(response.body)

    raise AddressLookupError, details["error"] unless response.status == 200

    addresses = details["results"]
    addresses.map do |address|
      { address.dig("LPI", "UPRN") => address.dig("LPI", "ADDRESS") }
    end
  end
end
