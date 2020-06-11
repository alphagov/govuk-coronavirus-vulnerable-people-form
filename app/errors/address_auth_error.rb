# typed: true
class AddressAuthError < StandardError
  def initialize
    super(I18n.t("coronavirus_form.api_errors.401"))
  end
end
