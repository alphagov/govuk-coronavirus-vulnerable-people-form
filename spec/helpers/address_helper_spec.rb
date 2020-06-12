require "spec_helper"

RSpec.describe AddressHelper, type: :helper do
  let(:address_data) { YAML.load_file(Rails.root.join("spec/fixtures/address_data.yml")) }

  describe "#postcode_lookup" do
    before do
      VCR.turn_on!
    end

    after do
      VCR.turn_off!
    end

    it "returns a UPRNs and address strings for a valid postcode" do
      VCR.use_cassette "postcode/valid_postcode" do
        response = helper.postcode_lookup(address_data["valid_postcode"]["postcode"])

        expect(response.count).to be(2)
        expect(response.first).to eq(
          {
            value: address_data["valid_postcode"]["value"],
            text: "10, DOWNING STREET, LONDON, CITY OF WESTMINSTER, SW1A 2AA",
          },
        )
      end
    end

    it "returns 400 a non-existant or malformed postcode" do
      VCR.use_cassette "postcode/non_existant" do
        expect {
          helper.postcode_lookup(address_data["invalid_postcode"]["postcode"])
        }.to raise_error(AddressLookupError)
      end
    end

    context "with an invalid api key" do
      before do
        allow(Rails.application.secrets).to receive(:os_api_key).and_return("1234")
      end
      it "returns 401 for an invalid api key" do
        VCR.use_cassette "postcode/invalid_api_key" do
          expect {
            helper.postcode_lookup(address_data["valid_postcode"]["postcode"])
          }.to raise_error(AddressAuthError)
        end
      end
    end

    it "raises an AddressNotFoundError for a postcode without any addresses" do
      VCR.use_cassette "postcode/no_addresses_found" do
        expect {
          helper.postcode_lookup(address_data["no_results"]["postcode"])
        }.to raise_error(AddressNotFoundError)
      end
    end
  end

  describe "#convert_address" do
    context "when SAO is present" do
      it "returns SAO on line 1 and PAO + STREET_DESCRIPTION on line 2" do
        address = {
          "ORGANISATION" => "GDS",
          "PAO_START_NUMBER" => "10",
          "STREET_DESCRIPTION" => "WHITECHAPEL HIGH STREET",
        }

        result = helper.convert_address(address)

        expect(result[:building_and_street_line_1]).to eq("Gds")
        expect(result[:building_and_street_line_2]).to eq("10 Whitechapel High Street")
      end
    end

    context "when SAO is not present" do
      it "returns PAO and STREET_DESCRIPTION on line 1" do
        address = {
          "PAO_START_NUMBER" => "10",
          "STREET_DESCRIPTION" => "WHITECHAPEL HIGH STREET",
        }

        result = helper.convert_address(address)

        expect(result[:building_and_street_line_1]).to eq("10 Whitechapel High Street")
      end
    end

    context "when SAO is not present but PAO_TEXT is" do
      it "return PAO on line 1 and STREET_DESCRIPTION on line 2" do
        address = {
          "PAO_TEXT" => "Flat 10",
          "STREET_DESCRIPTION" => "WHITECHAPEL HIGH STREET",
        }

        result = helper.convert_address(address)

        expect(result[:building_and_street_line_1]).to eq("Flat 10")
        expect(result[:building_and_street_line_2]).to eq("Whitechapel High Street")
      end
    end
  end

  describe "#make_address_hash" do
    it "creates an address hash containing only the required fields" do
      address = {
        "UPRN" => "1234",
        "UNNESESSARY" => "FIELD",
      }

      expect(helper.make_address_hash(address)).to eq({ "UPRN" => "1234" })
    end
  end

  describe "#update_support_address" do
    it "updates the UPRN when the ordnance_address address compares to the edited_address address" do
      ordnance_address = {
        uprn: "123456789",
        building_and_street_line_1: "address line 1",
        postcode: "1234 567",
      }

      edited_address = {
        building_and_street_line_1: "address line 1",
        postcode: "1234 567",
      }

      expect(helper.update_support_address(ordnance_address, edited_address).dig(:support_address, :uprn)).to eq("123456789")
    end
  end

  describe "#sanitize_address" do
    it "returns an empty array if the address is blank" do
      expect(helper.sanitize_address(nil)).to eq []
      expect(helper.sanitize_address({})).to eq []
    end

    it "returns a valid array if the address is present" do
      address = {
        one: "one two three 1234567890 ±§!@£$%^&*()_+-={}[]:\"|;'\<>?,./`~",
        postcode: "AA1A 1AA",
      }
      array = %w[1234567890 AA1A1AA ONE THREE TWO]

      expect(helper.sanitize_address(address)).to eq array
    end

    it "returns an array of strings if the address contains non-string values" do
      address = {
        string: "one",
        boolean: true,
        null: nil,
        integer: 100,
        float: 1.34,
        object: Object.new,
        struct: Struct.new("Ignored"),
        array: [],
        hash: {},
        symbol: :ignored,
        postcode: "AA1A 1AA",
      }
      array = %w[AA1A1AA ONE]

      expect(helper.sanitize_address(address)).to eq array
    end
  end

  describe "#sanitize_postcode" do
    it "removes non alphanumeric characters and whitespace" do
      expect(helper.sanitize_postcode(" _ A!A@1£A$ 1%A^A& -")).to eq "AA1A1AA"
    end
  end

  describe "#compare" do
    it "returns false if the ordnance address address is blank" do
      edited_address = {
        building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
        postcode: "E1 8QS",
      }

      expect(helper.compare(nil, edited_address)).to be false
      expect(helper.compare({}, edited_address)).to be false
    end

    it "returns false if the edited address is blank" do
      ordnance_address = {
        building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
        postcode: "E1 8QS",
      }

      expect(helper.compare(ordnance_address, nil)).to be false
      expect(helper.compare(ordnance_address, {})).to be false
    end

    it "returns true if nothing has changed" do
      address = {
        building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
        postcode: "E1 8QS",
      }

      expect(helper.compare(address, address)).to be true
    end

    it "returns true if something has been added but nothing has been removed" do
      ordnance_address = {
        building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
        postcode: "E1 8QS",
      }

      edited_address = {
        building_and_street_line_1: "10, Whitechapel High Street",
        building_and_street_line_2: "THIS WILL BE IGNORED",
        postcode: "e1 8qs",
      }

      expect(helper.compare(ordnance_address, edited_address)).to be true
    end

    it "returns true if anything is moved but not removed" do
      ordnance_address = {
        building_and_street_line_1: "HOUSE NAME",
        building_and_street_line_2: "WHITECHAPEL HIGH STREET",
        town_city: "LONDON",
        postcode: "E1 8QS",
      }

      edited_address = {
        building_and_street_line_1: "House Name, Whitechapel High Street, London",
        postcode: "E1 8QS",
      }

      expect(helper.compare(ordnance_address, edited_address)).to be true
    end

    it "returns false if anything has been removed from building_and_street_line_1" do
      ordnance_address = {
        building_and_street_line_1: "10, Whitechapel High Street",
        postcode: "E1 8QS",
      }

      edited_address = {
        building_and_street_line_1: "10, Whitechapel Street",
        postcode: "E1 8QS",
      }

      expect(helper.compare(ordnance_address, edited_address)).to be false
    end

    it "returns false if the postcode has been changed" do
      ordnance_address = { postcode: "E1 8QS" }
      edited_address = { postcode: "AA1A 1AA" }

      expect(helper.compare(ordnance_address, edited_address)).to be false
    end

    it "returns true if the county field has changed" do
      ordnance_address = {
        county: "LONDON",
        postcode: "E1 8QS",
      }

      edited_address = {
        county: "",
        postcode: "E1 8QS",
      }

      expect(helper.compare(ordnance_address, edited_address)).to be true
    end

    it "returns true if the town_city field has changed" do
      ordnance_address = {
        town_city: "GREATER LONDON",
        postcode: "E1 8QS",
      }

      edited_address = {
        town_city: "London",
        postcode: "E1 8QS",
      }

      expect(helper.compare(ordnance_address, edited_address)).to be true
    end
  end

  describe "#remove_changes_to_ordnance_survey_api_response" do
    it "returns the same address if all fields exist in the Ordance Survery Places API response definition and all values are strings" do
      selected_address = <<~ADDRESS.squish
        {
          "UPRN" : "123456789",
          "SAO_TEXT" : "FLAT 1",
          "PAO_TEXT" : "A BLOCK",
          "STREET_DESCRIPTION" : "BEDROCK STREET",
          "TOWN_NAME" : "BEDROCK",
          "ADMINISTRATIVE_AREA" : "GREATER BEDROCK",
          "POSTCODE_LOCATOR" : "BE1D 1RK"
        }
      ADDRESS

      returned_address = {
        "UPRN" => "123456789",
        "SAO_TEXT" => "FLAT 1",
        "PAO_TEXT" => "A BLOCK",
        "STREET_DESCRIPTION" => "BEDROCK STREET",
        "TOWN_NAME" => "BEDROCK",
        "ADMINISTRATIVE_AREA" => "GREATER BEDROCK",
        "POSTCODE_LOCATOR" => "BE1D 1RK",
      }

      expect(helper.remove_changes_to_ordnance_survey_api_response(selected_address)).to eq returned_address
    end

    it "removes all fields where the key does not exist in the Ordance Survery Places API response definition" do
      changed_selected_address = <<~ADDRESS.squish
        {
          "UPRN" : "123456789",
          "DANGER" : "FLAT 1",
          "WILL" : "A BLOCK",
          "ROBINSON" : "BEDROCK STREET",
          "TOWN_NAME" : "BEDROCK",
          "ADMINISTRATIVE_AREA" : "GREATER BEDROCK",
          "POSTCODE_LOCATOR" : "BE1D 1RK"
        }
      ADDRESS

      returned_address = {
        "UPRN" => "123456789",
        "TOWN_NAME" => "BEDROCK",
        "ADMINISTRATIVE_AREA" => "GREATER BEDROCK",
        "POSTCODE_LOCATOR" => "BE1D 1RK",
      }

      expect(helper.remove_changes_to_ordnance_survey_api_response(changed_selected_address)).to eq returned_address
    end

    it "removes all fields where the value is not a string" do
      changed_selected_address = <<~ADDRESS.squish
        {
          "UPRN" : "123456789",
          "SAO_TEXT" : null,
          "PAO_TEXT" : false,
          "STREET_DESCRIPTION" : 1.34,
          "TOWN_NAME" : 1234,
          "ADMINISTRATIVE_AREA" : "GREATER BEDROCK",
          "POSTCODE_LOCATOR" : "BE1D 1RK"
        }
      ADDRESS

      returned_address = {
        "UPRN" => "123456789",
        "ADMINISTRATIVE_AREA" => "GREATER BEDROCK",
        "POSTCODE_LOCATOR" => "BE1D 1RK",
      }

      expect(helper.remove_changes_to_ordnance_survey_api_response(changed_selected_address)).to eq returned_address
    end
  end
end
