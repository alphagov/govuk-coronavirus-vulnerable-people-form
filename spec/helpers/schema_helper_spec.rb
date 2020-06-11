# typed: false
require "spec_helper"

RSpec.describe SchemaHelper, type: :helper do
  include FormResponseHelper

  describe "#validate_against_form_response_schema" do
    it "returns nothing if the data is valid" do
      expect(validate_against_form_response_schema(valid_data)).to be_empty
    end

    describe "live_in_england" do
      it "returns a list of errors when live_in_england is missing" do
        data = valid_data.except(:live_in_england)
        expect(validate_against_form_response_schema(data).first).to include("live_in_england")
      end

      it "returns a list of errors when live_in_england has an unexpected value" do
        data = valid_data.merge(live_in_england: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("live_in_england")
      end
    end

    describe "nhs_letter" do
      it "returns a list of errors when nhs_letter is missing" do
        data = valid_data.except(:nhs_letter)
        expect(validate_against_form_response_schema(data).first).to include("nhs_letter")
      end

      it "returns a list of errors when nhs_letter has an unexpected value" do
        data = valid_data.merge(nhs_letter: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("nhs_letter")
      end
    end

    describe "medical_conditions" do
      it "allows medical_conditions to be blank" do
        data = valid_data.except(:medical_conditions)
        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when medical_conditions has an unexpected value" do
        data = valid_data.merge(medical_conditions: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("medical_conditions")
      end
    end

    describe "name" do
      it "returns a list of errors when name is missing" do
        data = valid_data.except(:name)
        expect(validate_against_form_response_schema(data).first).to include("name")
      end

      it "returns a list of errors when first_name is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:name].delete(:first_name)
        end

        expect(validate_against_form_response_schema(data).first).to include("first_name")
      end

      it "allows middle_name to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:name].delete(:middle_name)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when last_name is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:name].delete(:last_name)
        end

        expect(validate_against_form_response_schema(data).first).to include("last_name")
      end
    end

    describe "date_of_birth" do
      it "returns a list of errors when date_of_birth is missing" do
        data = valid_data.except(:date_of_birth)
        expect(validate_against_form_response_schema(data).first).to include("date_of_birth")
      end

      it "returns a list of errors when year is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:date_of_birth].delete(:year)
        end

        expect(validate_against_form_response_schema(data).first).to include("year")
      end

      it "returns a list of errors when month is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:date_of_birth].delete(:month)
        end

        expect(validate_against_form_response_schema(data).first).to include("month")
      end

      it "returns a list of errors when day is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:date_of_birth].delete(:day)
        end

        expect(validate_against_form_response_schema(data).first).to include("day")
      end
    end

    describe "support_address" do
      it "returns a list of errors when support_address is missing" do
        data = valid_data.except(:support_address)
        expect(validate_against_form_response_schema(data).first).to include("support_address")
      end

      it "returns a list of errors when building_and_street_line_1 is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:building_and_street_line_1)
        end

        expect(validate_against_form_response_schema(data).first).to include("building_and_street_line_1")
      end

      it "allows building_and_street_line_2 to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:building_and_street_line_2)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when town_city is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:town_city)
        end

        expect(validate_against_form_response_schema(data).first).to include("town_city")
      end

      it "allows county to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:county)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when postcode is missing" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:postcode)
        end

        expect(validate_against_form_response_schema(data).first).to include("postcode")
      end

      it "returns a list of errors when postcode has an invalid value" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address][:postcode] = "Foo"
        end

        expect(validate_against_form_response_schema(data).first).to include("postcode")
      end

      it "allows uprn to be unset" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address].delete(:uprn)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when uprn has an invalid value" do
        data = valid_data.tap do |valid_data|
          valid_data[:support_address][:uprn] = "Foo"
        end

        expect(validate_against_form_response_schema(data).first).to include("uprn")
      end
    end

    describe "contact_details" do
      it "allows contact_details to be blank" do
        data = valid_data.except(:contact_details)
        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "allows phone_number_calls to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details].delete(:phone_number_calls)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when phone_number_calls has an invalid value" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details][:phone_number_calls] = "Foo"
        end

        expect(validate_against_form_response_schema(data).first).to include("phone_number_calls")
      end

      it "allows phone_number_texts to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details].delete(:phone_number_texts)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when phone_number_texts has an invalid value" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details][:phone_number_texts] = "Foo"
        end

        expect(validate_against_form_response_schema(data).first).to include("phone_number_texts")
      end

      it "allows email to be blank" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details].delete(:email)
        end

        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when email has an invalid value" do
        data = valid_data.tap do |valid_data|
          valid_data[:contact_details][:email] = "Foo"
        end

        expect(validate_against_form_response_schema(data).first).to include("email")
      end
    end

    describe "know_nhs_number" do
      it "returns a list of errors when know_nhs_number is missing" do
        data = valid_data.except(:know_nhs_number)
        expect(validate_against_form_response_schema(data).first).to include("know_nhs_number")
      end

      it "returns a list of errors when know_nhs_number has an unexpected value" do
        data = valid_data.merge(know_nhs_number: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("know_nhs_number")
      end
    end

    describe "nhs_number" do
      it "allows nhs_number to be blank" do
        data = valid_data.except(:nhs_number)
        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when nhs_number has an unexpected value" do
        data = valid_data.merge(nhs_number: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("nhs_number")
      end
    end

    describe "essential_supplies" do
      it "returns a list of errors when essential_supplies is missing" do
        data = valid_data.except(:essential_supplies)
        expect(validate_against_form_response_schema(data).first).to include("essential_supplies")
      end

      it "returns a list of errors when essential_supplies has an unexpected value" do
        data = valid_data.merge(essential_supplies: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("essential_supplies")
      end
    end

    describe "basic_care_needs" do
      it "returns a list of errors when basic_care_needs is missing" do
        data = valid_data.except(:basic_care_needs)
        expect(validate_against_form_response_schema(data).first).to include("basic_care_needs")
      end

      it "returns a list of errors when basic_care_needs has an unexpected value" do
        data = valid_data.merge(basic_care_needs: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("basic_care_needs")
      end
    end

    describe "dietary_requirements" do
      it "returns a list of errors when dietary_requirements has an unexpected value" do
        data = valid_data.merge(dietary_requirements: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("dietary_requirements")
      end

      it "does not return a list of errors when dietary_requirements has a nil value" do
        data = valid_data.merge(dietary_requirements: nil)
        expect(validate_against_form_response_schema(data)).to be_empty
      end
    end

    describe "carry_supplies" do
      it "returns a list of errors when carry_supplies has an unexpected value" do
        data = valid_data.merge(carry_supplies: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("carry_supplies")
      end

      it "does not return a list of errors when carry_supplies has a nil value" do
        data = valid_data.merge(carry_supplies: nil)
        expect(validate_against_form_response_schema(data)).to be_empty
      end
    end

    describe "other information" do
      it "allows a reference_id to be stored" do
        data = valid_data.merge(reference_id: "abc")
        expect(validate_against_form_response_schema(data)).to be_empty
      end

      it "returns a list of errors when check_answers_seen has an invalid value" do
        data = valid_data.merge(check_answers_seen: "Foo")
        expect(validate_against_form_response_schema(data).first).to include("check_answers_seen")
      end

      it "returns errors for unnecessary session keys" do
        data = valid_data.merge(
          check_answers_seen: true,
          _csrf_token: "abc",
          current_path: "/foo",
          previous_path: "/foo",
          session_id: SecureRandom.uuid,
        )
        expect(validate_against_form_response_schema(data).first).to include(
          "check_answers_seen",
          "_csrf_token",
          "current_path",
          "previous_path",
          "session_id",
        )
      end
    end
  end
end
