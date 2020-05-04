require "spec_helper"

RSpec.describe AddressHelper, type: :helper do
  context "allow net connections" do
    before do
      VCR.turn_on!
    end

    after do
      VCR.turn_off!
    end

    context "200 - valid postcode" do
      it "returns all UPRN's for a valid estate block of self-contained flats" do
        VCR.use_cassette "address/200_estate_block" do
          response = helper.postcode_lookup("SW1P2LQ")

          expect(response.count).to be(16)
          expect(response.first).to eq(
            { "10033539608" => "FLAT 1, D BLOCK PEABODY ESTATE, OLD PYE STREET, LONDON, CITY OF WESTMINSTER, SW1P 2LQ" },
          )
        end
      end

      it "returns a UPRN for a building with it's own postcode" do
        VCR.use_cassette "address/200_individual_building" do
          response = helper.postcode_lookup("SW1A2AA")

          expect(response.count).to be(2)
          expect(response.first).to eq(
            { "100023336956" => "10, DOWNING STREET, LONDON, CITY OF WESTMINSTER, SW1A 2AA" },
          )
        end
      end
    end

    it "returns 400 a non-existant or malformed postcode" do
      VCR.use_cassette "address/400_response" do
        expect { helper.postcode_lookup("AA1A1AA") }.to raise_error(AddressLookupError)
      end
    end

    it "returns 401 for an invalid api key" do
      VCR.use_cassette "address/401_response" do
        ClimateControl.modify ORDNANCE_SURVEY_PLACES_API_KEY: "1234" do
          expect { helper.postcode_lookup("SW1A2AA") }.to raise_error(AddressLookupError)
        end
      end
    end
  end
end
