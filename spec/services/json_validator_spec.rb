require "spec_helper"

RSpec.describe JsonValidator do
  include FormResponseHelper

  let(:json_data) { valid_data }
  let(:schema_data) { File.read(Rails.root.join("config/schemas/form_response.json")) }
  let(:schema) { JSON.parse schema_data }
  subject(:json_validator) { described_class.new(schema, json_data) }

  describe "#valid?" do
    it "returns true if data is valid" do
      expect(json_validator.valid?).to be(true)
    end

    context "with invalid data" do
      let(:json_data) { valid_data.except(:live_in_england) }

      it "returns false" do
        expect(json_validator.valid?).to be(false)
      end
    end
  end

  describe "#errors" do
    let(:error) { json_validator.errors.first }

    it "returns no errors if the data is valid" do
      expect(json_validator.errors).to be_empty
    end

    context "when live_in_england is missing" do
      let(:json_data) { valid_data.except(:live_in_england) }

      it "returns a missing keys error" do
        expect(error).to eq({ "missing_keys" => %w[live_in_england] })
      end

      it 'does not include the "data" key values returned from validate' do
        expect(error["data"]).to be_nil
      end
    end

    context "when live_in_england is not valid" do
      let(:json_data) { valid_data.merge(live_in_england: "foo") }

      it "returns a yes_no definition error against the field" do
        expect(error["data"]).to eq("foo")
        expect(error["data_pointer"]).to include("live_in_england")
        expect(error["schema_pointer"]).to eq("/definitions/yes_no")
      end
    end

    context "when nhs_letter is missing" do
      let(:json_data) { valid_data.except(:nhs_letter) }

      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("nhs_letter")
      end
    end

    context "when nhs_letter is invalid" do
      let(:json_data) { valid_data.merge(nhs_letter: "foo") }

      it "returns an nhs_letter property error" do
        expect(error["data"]).to eq("foo")
        expect(error["data_pointer"]).to include("nhs_letter")
        expect(error["schema_pointer"]).to eq("/properties/nhs_letter")
      end
    end

    context "when medical_conditions is blank" do
      let(:json_data) { valid_data.except(:medical_conditions) }

      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context "when medical_conditions have an unexpected value" do
      let(:json_data) { valid_data.merge(medical_conditions: "foo") }

      it "returns a medical conditions property error" do
        expect(error["data"]).to eq("foo")
        expect(error["data_pointer"]).to include("medical_conditions")
        expect(error["schema_pointer"]).to eq("/properties/medical_conditions")
      end
    end

    context "when name is missing" do
      let(:json_data) { valid_data.except(:name) }

      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("name")
      end
    end

    context 'within "name"' do
      context "when first_name is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:name].delete(:first_name)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("first_name")
        end
      end

      context "when middle_name is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:name].delete(:middle_name)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when last_name is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:name].delete(:last_name)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("last_name")
        end
      end
    end

    context "when date_of_birth is missing" do
      let(:json_data) { valid_data.except(:date_of_birth) }

      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("date_of_birth")
      end
    end

    context 'within "date_of_birth"' do
      context "when year is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].delete(:year)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("year")
        end
      end

      context "when year is not a number" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].merge!({ year: "Two Thousand" })
          end
        end

        it "returns a property error" do
          expect(error["data"]).to eq("Two Thousand")
          expect(error["data_pointer"]).to eq("/date_of_birth/year")
          expect(error["schema_pointer"]).to eq("/properties/date_of_birth/properties/year")
        end
      end

      context "when month is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].delete(:month)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("month")
        end
      end

      context "when month is not a number" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].merge!({ month: "July" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("July")
          expect(error["data_pointer"]).to eq("/date_of_birth/month")
          expect(error["schema_pointer"]).to eq("/properties/date_of_birth/properties/month")
        end
      end

      context "when day is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].delete(:day)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("day")
        end
      end

      context "when year is not a number" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:date_of_birth].merge!({ day: "Third" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("Third")
          expect(error["data_pointer"]).to eq("/date_of_birth/day")
          expect(error["schema_pointer"]).to eq("/properties/date_of_birth/properties/day")
        end
      end
    end

    context "when support_address is missing" do
      let(:json_data) { valid_data.except(:support_address) }

      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("support_address")
      end
    end

    context 'within "support_address"' do
      context "when building_and_street_line_1 is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:building_and_street_line_1)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("building_and_street_line_1")
        end
      end

      context "when building_and_street_line_2 is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:building_and_street_line_2)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when town_city is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:town_city)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("town_city")
        end
      end

      context "when county is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:county)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when postcode is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:postcode)
          end
        end

        it "returns a missing keys error" do
          expect(error["missing_keys"]).to contain_exactly("postcode")
        end
      end

      context "when postcode is too short" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].merge!({ postcode: "SW1" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("SW1")
          expect(error["data_pointer"]).to eq("/support_address/postcode")
          expect(error["schema_pointer"]).to eq("/properties/support_address/properties/postcode")
        end
      end

      context "when postcode includes an invalid character" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].merge!({ postcode: "SW11NB!" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("SW11NB!")
          expect(error["data_pointer"]).to eq("/support_address/postcode")
          expect(error["schema_pointer"]).to eq("/properties/support_address/properties/postcode")
        end
      end

      context "when uprn is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].delete(:uprn)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when uprn format is incorrect" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:support_address].merge!({ uprn: "incorrect" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("incorrect")
          expect(error["data_pointer"]).to eq("/support_address/uprn")
          expect(error["schema_pointer"]).to eq("/properties/support_address/properties/uprn")
        end
      end
    end

    context "when contact_details is missing" do
      let(:json_data) { valid_data.except(:contact_details) }

      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context 'within "contact_details"' do
      context "when phone_number_calls is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].delete(:phone_number_calls)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when phone_number_calls is invalid" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].merge!({ phone_number_calls: "invalid" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("invalid")
          expect(error["data_pointer"]).to eq("/contact_details/phone_number_calls")
          expect(error["schema_pointer"]).to eq("/properties/contact_details/properties/phone_number_calls")
        end
      end

      context "when phone_number_texts is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].delete(:phone_number_texts)
          end
        end
        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when phone_number_calls is invalid" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].merge!({ phone_number_texts: "invalid" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("invalid")
          expect(error["data_pointer"]).to eq("/contact_details/phone_number_texts")
          expect(error["schema_pointer"]).to eq("/properties/contact_details/properties/phone_number_texts")
        end
      end

      context "when email is missing" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].delete(:email)
          end
        end

        it "returns no errors" do
          expect(json_validator.errors).to be_empty
        end
      end

      context "when email is invalid" do
        let(:json_data) do
          valid_data.tap do |valid_data|
            valid_data[:contact_details].merge!({ email: "invalid" })
          end
        end

        it "returns a properties error" do
          expect(error["data"]).to eq("invalid")
          expect(error["data_pointer"]).to eq("/contact_details/email")
          expect(error["schema_pointer"]).to eq("/properties/contact_details/properties/email")
        end
      end
    end

    context "when know_nhs_number is missing" do
      let(:json_data) { valid_data.except(:know_nhs_number) }
      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("know_nhs_number")
      end
    end

    context "when know_nhs_number is invalid" do
      let(:json_data) { valid_data.merge(know_nhs_number: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/know_nhs_number")
        expect(error["schema_pointer"]).to eq("/properties/know_nhs_number")
      end
    end

    context "when nhs_number is missing" do
      let(:json_data) { valid_data.except(:nhs_number) }

      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context "when nhs_number is invalid" do
      let(:json_data) { valid_data.merge(nhs_number: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/nhs_number")
        expect(error["schema_pointer"]).to eq("/properties/nhs_number")
      end
    end

    context "when essential_supplies is missing" do
      let(:json_data) { valid_data.except(:essential_supplies) }

      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("essential_supplies")
      end
    end

    context "when essential_supplies is invalid" do
      let(:json_data) { valid_data.merge(essential_supplies: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/essential_supplies")
        expect(error["schema_pointer"]).to eq("/definitions/yes_no")
      end
    end

    context "when basic_care_needs is missing" do
      let(:json_data) { valid_data.except(:basic_care_needs) }
      it "returns a missing keys error" do
        expect(error["missing_keys"]).to contain_exactly("basic_care_needs")
      end
    end

    context "when basic_care_needs is invalid" do
      let(:json_data) { valid_data.merge(basic_care_needs: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/basic_care_needs")
        expect(error["schema_pointer"]).to eq("/definitions/yes_no")
      end
    end

    context "when dietary_requirements is missing" do
      let(:json_data) { valid_data.except(:dietary_requirements) }
      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context "when dietary_requirements is invalid" do
      let(:json_data) { valid_data.merge(dietary_requirements: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/dietary_requirements")
        expect(error["schema_pointer"]).to eq("/definitions/yes_no_optional")
      end
    end

    context "when carry_supplies is missing" do
      let(:json_data) { valid_data.except(:carry_supplies) }
      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context "when carry_supplies is invalid" do
      let(:json_data) { valid_data.merge(carry_supplies: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/carry_supplies")
        expect(error["schema_pointer"]).to eq("/definitions/yes_no_optional")
      end
    end

    context "when reference_id is present" do
      let(:json_data) { valid_data.merge(reference_id: "abc") }
      it "returns no errors" do
        expect(json_validator.errors).to be_empty
      end
    end

    context "when check_answers_seen is invalid" do
      let(:json_data) { valid_data.merge(check_answers_seen: "invalid") }

      it "returns a properties error" do
        expect(error["data"]).to eq("invalid")
        expect(error["data_pointer"]).to eq("/check_answers_seen")
        expect(error["schema_pointer"]).to eq("/additionalProperties")
      end
    end

    context "when unnecessary session keys are present" do
      let(:unnecessary_keys) do
        {
          check_answers_seen: true,
          _csrf_token: "abc",
          current_path: "/foo",
          previous_path: "/foo",
          session_id: SecureRandom.uuid,
        }
      end
      let(:json_data) { valid_data.merge(unnecessary_keys) }

      it "returns errors" do
        expect(json_validator.errors.length).to eq(unnecessary_keys.length)
      end

      it "return an error for each key" do
        keys = unnecessary_keys.keys.map { |k| "/#{k}" }
        data_points = json_validator.errors.map { |e| e["data_pointer"] }
        expect(data_points).to contain_exactly(*keys)
      end

      it "returns additionalProperties errors" do
        errors = json_validator.errors.map { |e| e["schema_pointer"] }.uniq
        expect(errors).to eq(["/additionalProperties"])
      end
    end
  end
end
