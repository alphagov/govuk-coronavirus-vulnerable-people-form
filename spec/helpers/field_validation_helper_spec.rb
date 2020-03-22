require "spec_helper"

RSpec.describe FieldValidationHelper, type: :helper do
  context "#validate_date_of_birth" do
    it "returns an error if year is blank" do
      invalid_fields = validate_date_of_birth("", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_of_birth("1990", "", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_of_birth("1990", "6", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter your date of birth and include a day, month and year" }]
    end

    it "returns an error if year is negative" do
      invalid_fields = validate_date_of_birth("-1990", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: "Enter a real year" }]
    end

    it "returns an error if month is negative" do
      invalid_fields = validate_date_of_birth("1990", "-6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: "Enter a real month" }]
    end

    it "returns an error if day is negative" do
      invalid_fields = validate_date_of_birth("1990", "6", "-25", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter a real day" }]
    end

    it "returns an error if no date is entered" do
      invalid_fields = validate_date_of_birth("", "", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter your date of birth" }]
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_of_birth("", "", "25", "date")
      expect(invalid_fields).to eq [
        { field: "date-month", text: "Enter your date of birth and include a day, month and year" },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_of_birth("2019", "02", "30", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: "Enter a real date of birth" }]
    end

    it "returns an error if date is in the future" do
      Timecop.freeze("2019-03-22") do
        invalid_fields = validate_date_of_birth("2020", "02", "01", "date")
        expect(invalid_fields).to eq [{ field: "date-day", text: "Date of birth must be in the past" }]
      end
    end
  end
end
