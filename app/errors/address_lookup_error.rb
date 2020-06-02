class AddressLookupError < StandardError
  def initialize(code)
    super(
      I18n.t(
        "coronavirus_form.api_errors.#{code}",
        default: I18n.t("coronavirus_form.api_errors.error"),
      )
    )
  end
end
