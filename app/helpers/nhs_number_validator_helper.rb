# frozen_string_literal: true

module NhsNumberValidatorHelper
  def call(number)
    return false unless number.is_a? Numeric
    return false unless is_ten_digits?(number)
    return false unless valid_check_digit?(number)
    true
  end

  def is_ten_digits?(number)
    number.to_s.length == 10
  end

  def valid_check_digit?(number)
    last_digit = number.to_s.chars.last.to_i
    return last_digit == check_digit(number)
  end

  def check_digit(number)
    total = multiply_nine_digits_by_factor(number)
    interim = 11 - (total % 11)
    return -1 if interim == 10
    return 0 if interim == 11
    return interim
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
