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
    it "updates the UPRN when the selected address compares to the given address" do
      selected = {
        uprn: "123456789",
        building_and_street_line_1: "address line 1",
        postcode: "1234 567",
      }

      given = {
        building_and_street_line_1: "address line 1",
        postcode: "1234 567",
      }

      expect(helper.update_support_address(selected, given).dig(:support_address, :uprn)).to eq("123456789")
    end
  end

  describe "#compare" do
    it "returns false if the selected address is empty" do
      expect(helper.compare({}, {})).to be false
    end

    context "SAO is true" do
      it "returns true if first two lines plus the postcode are equivalent" do
        selected = {
          sao_present: true,
          building_and_street_line_1: "GDS",
          building_and_street_line_2: "10 WHITECHAPEL HIGH STREET",
          postcode: "E18QS",
        }

        given = {
          building_and_street_line_1: "Gds",
          building_and_street_line_2: "10, Whitechapel High Street",
          postcode: "E18QS",
        }

        expect(helper.compare(selected, given)).to be true
      end
    end

    context "SAO is false" do
      it "returns true if first line and postcode are equivalent" do
        selected = {
          sao_present: false,
          building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
          postcode: "E18QS",
        }

        given = {
          building_and_street_line_1: "10, Whitechapel High Street",
          building_and_street_line_2: "THIS DOES NOT MATTER",
          postcode: "E18QS",
        }

        expect(helper.compare(selected, given)).to be true
      end

      it "returns false if the postcodes do not match" do
        selected = {
          sao_present: false,
          building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
          postcode: "E18QS",
        }

        given = {
          building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
          postcode: "AA1A1AA",
        }

        expect(helper.compare(selected, given)).to be false
      end

      it "returns false if the first lines do not match" do
        selected = {
          sao_present: false,
          building_and_street_line_1: "10 WHITECHAPEL HIGH STREET",
          postcode: "E18QS",
        }

        given = {
          building_and_street_line_1: "10 DOWNING STREET",
          postcode: "E18QS",
        }

        expect(helper.compare(selected, given)).to be false
      end

      it "returns true if street description is moved from line 2 to line 1" do
        selected = {
          sao_present: false,
          building_and_street_line_1: "HOUSE NAME",
          building_and_street_line_2: "WHITECHAPEL HIGH STREET",
          postcode: "E18QS",
        }

        given = {
          building_and_street_line_1: "House Name, Whitechapel High Street",
          postcode: "E18QS",
        }

        expect(helper.compare(selected, given)).to be true
      end
    end
  end
end
