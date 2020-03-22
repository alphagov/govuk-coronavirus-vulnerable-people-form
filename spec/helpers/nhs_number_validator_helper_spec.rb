require "spec_helper"

RSpec.describe NhsNumberValidatorHelper, :type => :helper do
  context "with a correct length number" do
    it "returns true when a valid nhs number is passed in" do
      [1234567881, 9434765919, 9434765870, 9434765919, 4012032135].each do |n|
        expect(helper.call(n)).to be(true), "#{n} should be valid"
      end
    end

    it "should return false when an invalid nhs number is passed in" do
      expect(helper.call(1234567890)).to be false
    end
  end

  context "check digit" do
    it "returns -1 when check digit is 10" do
      expect(helper.check_digit(1234567890)).to be -1
    end

    it "returns 1 when the nhs number is 123456788" do
      expect(helper.check_digit(1234567881)).to be 1
    end

    it "returns 0 when check digit is 11" do
      expect(helper.check_digit(1645418822)).to be 0
    end
  end

  context "type" do
    it "should not be a string" do
      expect(helper.call("onetwothre")).to be false
    end

    it "should be a number" do
      expect(helper.call("1234567890")).to be false
    end
  end

  context "length of the nhs number" do
    it "should not be more than 10 digits" do
      expect(helper.call(12345678901)).to be false
    end

    it "should not be less than 10 digits" do
      expect(helper.call(123456789)).to be false
      expect(helper.call(1)).to be false
    end

    it "should not be empty" do
      expect(helper.call("")).to be false
    end

    it "should not be nil" do
      expect(helper.call(nil)).to be false
    end
  end
end
