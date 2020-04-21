require "spec_helper"

RSpec.describe FieldValidationHelper, type: :helper do
  context "#validate_date_of_birth" do
    it "does not return an error for a valid date" do
      Timecop.freeze("2019-04-21") do
        invalid_fields = validate_date_of_birth("1970", "02", "01", "date")
        expect(invalid_fields).to be_empty
      end
    end

    it "returns an error if year is blank" do
      invalid_fields = validate_date_of_birth("", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: I18n.t("coronavirus_form.errors.missing_fields") }]
    end

    it "returns an error if month is blank" do
      invalid_fields = validate_date_of_birth("1990", "", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: I18n.t("coronavirus_form.errors.missing_fields") }]
    end

    it "returns an error if day is blank" do
      invalid_fields = validate_date_of_birth("1990", "6", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.missing_fields") }]
    end

    it "returns an error if year is negative" do
      invalid_fields = validate_date_of_birth("-1990", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: I18n.t("coronavirus_form.errors.negative_date", field: "year") }]
    end

    it "returns an error if month is negative" do
      invalid_fields = validate_date_of_birth("1990", "-6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: I18n.t("coronavirus_form.errors.negative_date", field: "month") }]
    end

    it "returns an error if day is negative" do
      invalid_fields = validate_date_of_birth("1990", "6", "-25", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.negative_date", field: "day") }]
    end

    it "returns an error if year is not a number" do
      invalid_fields = validate_date_of_birth("Foo", "6", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: I18n.t("coronavirus_form.errors.date_not_a_number", field: "year") }]
    end

    it "returns an error if month is not a number" do
      invalid_fields = validate_date_of_birth("1990", "Foo", "25", "date")
      expect(invalid_fields).to eq [{ field: "date-month", text: I18n.t("coronavirus_form.errors.date_not_a_number", field: "month") }]
    end

    it "returns an error if day is not a number" do
      invalid_fields = validate_date_of_birth("1990", "6", "Foo", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.date_not_a_number", field: "day") }]
    end

    it "returns an error if no date is entered" do
      invalid_fields = validate_date_of_birth("", "", "", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.missing_date") }]
    end

    it "returns multiple errors if multiple date fields are blank" do
      invalid_fields = validate_date_of_birth("", "", "25", "date")
      expect(invalid_fields).to eq [
        { field: "date-month", text: I18n.t("coronavirus_form.errors.missing_fields") },
      ]
    end

    it "returns an error if date is not valid" do
      invalid_fields = validate_date_of_birth("2019", "02", "30", "date")
      expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.invalid_date") }]
    end

    it "returns an error if date is in the future" do
      Timecop.freeze("2019-03-22") do
        invalid_fields = validate_date_of_birth("2020", "02", "01", "date")
        expect(invalid_fields).to eq [{ field: "date-day", text: I18n.t("coronavirus_form.errors.date_order") }]
      end
    end

    it "returns an error if date is more than 150 years ago" do
      invalid_fields = validate_date_of_birth("1869", "02", "01", "date")
      expect(invalid_fields).to eq [{ field: "date-year", text: I18n.t("coronavirus_form.errors.invalid_date") }]
    end
  end
end
