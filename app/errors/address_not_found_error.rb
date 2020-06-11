# typed: true
class AddressNotFoundError < StandardError
  def initialize(postcode)
    super(I18n.t("coronavirus_form.api_errors.no_addresses_found", postcode: postcode))
  end
end
