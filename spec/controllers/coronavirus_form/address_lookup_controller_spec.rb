# typed: false
# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AddressLookupController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/address_lookup" }
  let(:session_key) { :support_address }
  let(:next_page) { support_address_path }
  let(:address_data) { YAML.load_file(Rails.root.join("spec/fixtures/address_data.yml")) }

  before do
    VCR.turn_on!
  end

  after do
    VCR.turn_off!
  end

  describe "GET show" do
    before do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
    end

    context "valid postcode" do
      it "renders the postcode form" do
        VCR.use_cassette "/postcode/valid_postcode" do
          session[:support_address] = { postcode: address_data["valid_postcode"]["postcode"] }
          get :show
          expect(response).to render_template(current_template)
        end
      end
    end

    context "when the OS API times out" do
      before do
        VCR.turn_off!
      end

      it "redirects to postcode lookup page" do
        stub_request(:get, /#{AddressHelper::API_HOSTNAME}/).to_raise(Faraday::TimeoutError)

        session[:support_address] = { postcode: address_data["invalid_postcode"]["postcode"] }
        get :show

        expect(response).to redirect_to(postcode_lookup_path)
      end
    end

    context "invalid postcode" do
      it "renders an error message if the postcode is invalid" do
        VCR.use_cassette "/postcode/non_existant" do
          session[:support_address] = { postcode: address_data["invalid_postcode"]["postcode"] }

          get :show

          expect(response).to redirect_to(postcode_lookup_path)
        end
      end
    end

    context "API key is invalid" do
      before :each do
        allow(Rails.application.secrets).to receive(:os_api_key).and_return("1234")
      end
      it "calls GovukError and redirects to support_address_path" do
        VCR.use_cassette "/postcode/invalid_api_key" do
          session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
          session[:support_address] = { postcode: address_data["valid_postcode"]["postcode"] }

          expect(GovukError).to receive(:notify)
          get :show
          expect(response).to redirect_to(support_address_path)
        end
      end
    end
  end

  describe "POST submit" do
    before :each do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
    end

    it "adds address data to the session and redirects to the support address path" do
      post :submit, params: { address: address_data["valid_postcode"]["value"] }

      expect(session[:support_address][:postcode]).to eq(address_data["valid_postcode"]["postcode"])
      expect(response).to redirect_to(support_address_path)
    end

    context "when address is not selected" do
      it "returns a 400 error" do
        post :submit, params: { address: nil }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when address is not in expected format" do
      it "returns a 400 error" do
        post :submit, params: { address: "a lovely string<script>alert(1)</script>" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
