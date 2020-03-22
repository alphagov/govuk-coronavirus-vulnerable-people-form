require "spec_helper"

RSpec.describe FieldValidationHelper, type: :helper do
  context "#validate_date_fields" do
    it "returns an error if year is blank" do
      invalid_fields = validate_date_fields("", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_fields("1990", "", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_fields("1990", "6", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if year is negative" do
      invalid_fields = validate_date_fields("-1990", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: "Enter a real year" }]
    end

    it "returns an error if month is negative" do
      invalid_fields = validate_date_fields("1990", "-6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: "Enter a real month" }]
    end

    it "returns an error if day is negative" do
      invalid_fields = validate_date_fields("1990", "6", "-25", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter a real day" }]
    end

    it "returns an error if no date is entered" do
      invalid_fields = validate_date_fields("", "", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter your date of birth" }]
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_fields("", "", "25", "date")
      expect(invalid_fields).to eq [
        { field: "date-month", text: "Enter your date of birth and include a day, month and year" },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_fields("2019", "02", "30", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter a real date of birth" }]
    end
  end
end
