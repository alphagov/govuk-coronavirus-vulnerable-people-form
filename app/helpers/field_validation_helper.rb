# frozen_string_literal: true

module FieldValidationHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      next unless session[field].blank?

      invalid_fields << { field: field.to_s,
                          text: t("coronavirus_form.#{page}.#{field}.custom_error",
                                  default: t('coronavirus_form.errors.missing_mandatory_text_field', field: t("coronavirus_form.#{page}.#{field}.label")).humanize) }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, allowed_values:, other: false)
    if radio.blank? || allowed_values.exclude?(radio)
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.#{page}.custom_select_error",
                  default: t('coronavirus_form.errors.radio_field', field: t("coronavirus_form.#{page}.title")).humanize
                ) }]
    end

    if other != false && other.blank? && %w[Yes Other].include?(radio)
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.#{page}.custom_enter_error",
                  default: t('coronavirus_form.errors.missing_mandatory_text_field', field: t("coronavirus_form.#{page}.title")).humanize
                ) }]
    end

    []
  end

  def validate_checkbox_field(page, values:, allowed_values:)
    if values.blank? || values.empty?
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.#{page}.custom_select_error",
                  default: t('coronavirus_form.errors.checkbox_field', field: t("coronavirus_form.#{page}.title")).humanize
                ) }]
    end

    if (values - allowed_values).any?
      return [{ field: page.to_s,
                text: t(
                  "coronavirus_form.#{page}.custom_select_error",
                  default: t('coronavirus_form.errors.missing_mandatory_text_field', field: t("coronavirus_form.#{page}.title")).humanize
                ) }]
    end

    []
  end

  def validate_email_address(field, email_address)
    if email_address =~ /@/
      []
    else
      [{ field: field.to_s, text: t('coronavirus_form.errors.email_format') }]
    end
  end

  def validate_postcode(field, postcode)
    if postcode =~ /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i
      []
    else
      [{ field: field.to_s, text: t('coronavirus_form.errors.postcode_format') }]
    end
  end
end
