# typed: strict
class AddressAuthError < StandardError
  extend T::Sig

  sig { returns AddressAuthError }
  def initialize
    super(I18n.t("coronavirus_form.api_errors.401"))
  end
end
