# frozen_string_literal: true

module NhsNumberValidatorHelper
  def validate_nhs_number_correctness(number)
    if number.nil? || number.blank?
      {
        valid: false,
        message: I18n.t("coronavirus_form.questions.nhs_number.nhs_number.custom_errors.missing"),
      }
    elsif !is_number?(number)
      {
        valid: false,
        message: I18n.t("coronavirus_form.questions.nhs_number.nhs_number.custom_errors.must_be_a_number"),
      }
    elsif !is_ten_digits?(number)
      {
        valid: false,
        message: I18n.t("coronavirus_form.questions.nhs_number.nhs_number.custom_errors.must_be_ten_digits"),
      }
    elsif !valid_check_digit?(number.to_i)
      {
        valid: false,
        message: I18n.t("coronavirus_form.questions.nhs_number.nhs_number.custom_errors.must_have_checksum"),
      }
    else
      {
        valid: true,
      }
    end
  end

  def is_number?(string)
    true if Integer(string)
  rescue StandardError
    false
  end

  def is_ten_digits?(number)
    number.to_s.length == 10
  end

  def valid_check_digit?(number)
    last_digit = number.to_s.chars.last.to_i
    last_digit == check_digit(number)
  end

  def check_digit(number)
    total = multiply_nine_digits_by_factor(number)
    interim = 11 - (total % 11)
    return -1 if interim == 10
    return 0 if interim == 11

    interim
  end

  def multiply_nine_digits_by_factor(number)
    total = 0
    number.to_s.chars.take(9).each_with_index do |num, i|
      total += num.to_i * factor[i]
    end
    total
  end

  def factor
    [10, 9, 8, 7, 6, 5, 4, 3, 2]
  end
end
