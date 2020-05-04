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

    it "returns 404 for an invalid or unavailable service request" do
      VCR.use_cassette "address/404_response" do
        stub_const(
          "AddressHelper::API_URL",
          "https://api.ordnancesurvey.co.uk/places/v99999999/addresses/postcode?dataset=LPI",
        )

        expect { helper.postcode_lookup("AA1A1AA") }.to raise_error(AddressLookupError)
      end
    end

    it "returns 500 for a request with an invalid method" do
      VCR.use_cassette "address/500_response" do
        expect { helper.postcode_lookup("SW1A2AA") }.to raise_error(AddressLookupError)
      end
    end
  end

  context "disable net connections" do
    # The API documentation implies that it can return a 405.  However, so far
    # it has not been possible to generate one.  Until that it is possible to
    # generate a 405 a stub has been added for testing purposes.  Note: that
    # OS return a 500 for a not allowed method instead!
    it "returns 405 for a method not allowed request" do
      stub_const(
        "AddressHelper::API_URL",
        "https://api.ordnancesurvey.co.uk/placezzzzzzzzzz/v1/addresses/postcode?dataset=LPI",
      )

      postcode = "SW1A2AA"
      postcode_url = "#{AddressHelper::API_URL}&postcode=#{postcode}&key=#{ENV['ORDNANCE_SURVEY_PLACES_API_KEY']}"

      stub_request(:get, postcode_url)
        .to_return(status: 405, body: {}.to_s, headers: {})

      expect { helper.postcode_lookup(postcode) }.to raise_error(AddressLookupError)
    end
  end
end
