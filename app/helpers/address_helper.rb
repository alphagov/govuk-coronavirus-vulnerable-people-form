# frozen_string_literal: true

module AddressHelper
  UPRN = %w[UPRN].freeze
  SAO = %w[ORGANISATION SAO_START_NUMBER SAO_START_SUFFIX SAO_END_NUMBER SAO_END_SUFFIX SAO_TEXT].freeze
  PAO = %w[PAO_START_NUMBER PAO_START_SUFFIX PAO_END_NUMBER PAO_END_SUFFIX PAO_TEXT].freeze
  STREET = %w[STREET_DESCRIPTION].freeze
  TOWN_CITY = %w[LOCALITY_NAME TOWN_NAME].freeze
  COUNTY = %w[ADMINISTRATIVE_AREA AREA_NAME].freeze
  POSTCODE = %w[POSTCODE_LOCATOR].freeze

  WANTED_VALUES = UPRN + SAO + PAO + STREET + TOWN_CITY + COUNTY + POSTCODE

  LINE_1_AND_POSTCODE = %i[building_and_street_line_1 postcode].freeze
  LINE_1_2_AND_POSTCODE = %i[building_and_street_line_1 building_and_street_line_2 postcode].freeze

  API_HOSTNAME = "https://api.ordnancesurvey.co.uk"

  def api_url_builder(resource_name, resource)
    "#{API_HOSTNAME}/places/v1/addresses/#{resource_name}?dataset=LPI&#{resource_name}=#{resource}&key=#{Rails.application.secrets.os_api_key}"
  end

  def os_api_caller(url)
    response = Faraday.get(url)

    raise AddressAuthError if response.status == 401
    raise AddressLookupError, response.status unless response.status == 200

    JSON.parse(response.body)
  rescue Faraday::Error
    raise AddressLookupError, 502
  end

  def postcode_lookup(postcode)
    response = os_api_caller(api_url_builder("postcode", postcode))

    raise AddressNotFoundError, postcode if response["header"]["totalresults"].zero?

    response["results"].map do |address|
      {
        text: address.dig("LPI", "ADDRESS"),
        value: JSON.generate(address.dig("LPI").slice(*WANTED_VALUES)),
      }
    end
  end

  def convert_address(address)
    raw_address = address.slice(*WANTED_VALUES)

    sao = address_line_builder(raw_address, SAO).titleize
    pao = address_line_builder(raw_address, PAO).titleize
    street = address_line_builder(raw_address, STREET).titleize

    return_hash = {
      uprn: address_line_builder(raw_address, UPRN),
      building_and_street_line_1: "",
      building_and_street_line_2: "",
      town_city: address_line_builder(raw_address, TOWN_CITY).titleize,
      county: address_line_builder(raw_address, COUNTY).titleize,
      postcode: address_line_builder(raw_address, POSTCODE).delete(" "),
    }

    if sao.present?
      return_hash[:building_and_street_line_1] = sao
      return_hash[:building_and_street_line_2] = pao + " " + street
    elsif address_line_builder(raw_address, %w[PAO_TEXT]).present?
      return_hash[:building_and_street_line_1] = pao
      return_hash[:building_and_street_line_2] = street
    else
      return_hash[:building_and_street_line_1] = pao + " " + street
    end

    return_hash
  end

  def address_line_builder(raw_address, fields, delimiter = ", ")
    raw_address.slice(*fields).values.join(delimiter)
  end

  def address_comparison_line_builder(raw_address, fields)
    address_line_builder(raw_address, fields, "").gsub(/\W+/, "").upcase
  end

  def make_address_hash(address)
    address.slice(*WANTED_VALUES)
  end

  def update_support_address(ordnance_address, edited_address)
    edited_address[:uprn] = ordnance_address[:uprn] if compare(ordnance_address, edited_address)
    { support_address: edited_address }
  end

  def sanitize_postcode(postcode)
    postcode.gsub(/[^0-9a-zA-Z]+/, "")
  end

  def sanitize_address(address)
    return [] if address.blank?

    if address.values.any?
      copy_of_address = address
      copy_of_address[:postcode] = sanitize_postcode(address[:postcode])

      copy_of_address
        .with_indifferent_access
        .except(:uprn, :county, :town_city)
        .values
        .map(&:upcase).join(" ")
        .gsub(/[^0-9A-Z]+/, " ")
        .split(" ")
        .sort
        .compact
    end
  end

  def compare(ordnance_address, edited_address)
    return false if ordnance_address.blank?

    sanitized_ordnance_address = sanitize_address(ordnance_address)
    sanitized_edited_address = sanitize_address(edited_address)

    sanitized_edited_address & sanitized_ordnance_address == sanitized_ordnance_address
  end
end
