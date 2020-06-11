# typed: false
require "spec_helper"

RSpec.describe NhsNumberValidatorHelper, type: :helper do
  context "with a correct length number" do
    it "returns true when a valid nhs number is passed in" do
      [1234567881, 9434765919, 9434765870, 9434765919, 4012032135].each do |n|
        expect(helper.validate_nhs_number_correctness(n)[:valid]).to be(true), "#{n} should be valid"
      end
    end

    it "should return false when an invalid nhs number is passed in" do
      expect(helper.validate_nhs_number_correctness(1234567890)[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(1234567890)[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.must_have_checksum")
    end
  end

  context "check digit" do
    it "returns -1 when check digit is 10" do
      expect(helper.check_digit(1234567890)).to be(-1)
    end

    it "returns 1 when the nhs number is 123456788" do
      expect(helper.check_digit(1234567881)).to be(1)
    end

    it "returns 0 when check digit is 11" do
      expect(helper.check_digit(1645418822)).to be(0)
    end
  end

  context "type" do
    it "should not be a non numeric string" do
      expect(helper.validate_nhs_number_correctness("onetwothre")[:valid]).to be false
      expect(helper.validate_nhs_number_correctness("onetwothre")[:message])
        .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.must_be_a_number")
    end

    it "should be valid a numeric string" do
      expect(helper.validate_nhs_number_correctness("1234567881")[:valid]).to be true
    end
  end

  context "length of the nhs number" do
    it "should not be more than 10 digits" do
      expect(helper.validate_nhs_number_correctness(12345678901)[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(12345678901)[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.must_be_ten_digits")
    end

    it "should not be less than 10 digits" do
      expect(helper.validate_nhs_number_correctness(123456789)[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(1)[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(1)[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.must_be_ten_digits")
    end

    it "should not be empty" do
      expect(helper.validate_nhs_number_correctness("")[:valid]).to be false
      expect(helper.validate_nhs_number_correctness("")[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.missing")

      expect(helper.validate_nhs_number_correctness(" ")[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(" ")[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.missing")
    end

    it "should not be nil" do
      expect(helper.validate_nhs_number_correctness(nil)[:valid]).to be false
      expect(helper.validate_nhs_number_correctness(nil)[:message])
      .to eq I18n.t("coronavirus_form.questions.nhs_number..nhs_number.custom_errors.missing")
    end
  end
end
