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
    context "valid postcode" do
      it "renders the postcode form" do
        VCR.use_cassette "/postcode/valid_postcode" do
          session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
          session[:postcode] = address_data["valid_postcode"]["postcode"]

          get :show
          expect(response).to render_template(current_template)
        end
      end
    end

    context "invalid postcode" do
      it "renders an error message if the postcode is invalid" do
        VCR.use_cassette "/postcode/non_existant" do
          session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
          session[:postcode] = address_data["invalid_postcode"]["postcode"]

          get :show

          expect(response).to redirect_to(postcode_lookup_path)
        end
      end
    end
  end

  describe "POST submit" do
    it "adds address data to the session and redirects to the support address path" do
      VCR.use_cassette "/uprn/valid_uprn" do
        session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
        post :submit, params: { uprn: address_data["valid_postcode"]["uprn"] }

        expect(session[:support_address][:postcode]).to eq(address_data["valid_postcode"]["postcode"])
        expect(response).to redirect_to(support_address_path)
      end
    end

    context "check answer page already visited" do
      it "redirect to the check answers page" do
        session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
        session[:check_answers_seen] = true

        post :submit

        expect(response).to redirect_to(check_your_answers_path)
      end
    end
  end
end
