# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::SupportAddressController, type: :controller do
  let(:current_template) { "coronavirus_form/support_address" }
  let(:session_key) { :support_address }
  let(:next_page) { contact_details_path }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = "Yes"

      get :show
      expect(response).to render_template(current_template)
    end

    it "redirects to start if no session data" do
      get :show
      expect(response).to redirect_to(live_in_england_path)
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        "building_and_street_line_1" => "<script></script>Ministry of Magic",
        "building_and_street_line_2" => "1 Horse Guards Road<script></script>",
        "town_city" => "<script></script>London",
        "county" => "United Kingdom",
        "postcode" => "SW1A 2HQ",
      }
    end
    let(:address) do
      {
        "building_and_street_line_1" => "Ministry of Magic",
        "building_and_street_line_2" => "1 Horse Guards Road",
        "town_city" => "London",
        "county" => "United Kingdom",
        "postcode" => "SW1A 2HQ",
      }
    end

    it "sets session variables" do
      post :submit, params: params

      expect(session[session_key]).to eq address
    end

    it "does not require address line 2" do
      post :submit, params: params.except("building_and_street_line_2")

      expect(session[session_key]).to eq address.merge("building_and_street_line_2" => nil)
      expect(response).to redirect_to(next_page)
    end

    it "redirects to next page when provided address line 1, town and postcode" do
      post :submit, params: params.except("building_and_street_line_2", "county")

      expect(session[session_key]).to eq address.merge({
        "building_and_street_line_2" => nil,
        "county" => nil,
        })

      expect(response).to redirect_to(next_page)
    end

    it "redirects to next page when provided address line 1, town and county" do
      post :submit, params: params.except("building_and_street_line_2", "postcode")

      expect(session[session_key]).to eq address.merge({
        "building_and_street_line_2" => nil,
        "postcode" => nil,
        })

      expect(response).to redirect_to(next_page)
    end

    it "redirects to next step when all fields are provided" do
      post :submit, params: params

      expect(response).to redirect_to(next_page)
    end

    it "redirects to next step when postcode is valid" do
      valid_postcodes = [
        "AA9A 9AA",
        "A9A 9AA",
        "A9 9AA",
        "A99 9AA",
        "AA9 9AA",
        "AA99 9AA",
        "BFPO 1",
        "BFPO 9",
      ]

      valid_postcodes.each do |postcode|
        params["postcode"] = postcode
        post :submit, params: params

        expect(response).to redirect_to(next_page)
      end
    end

    it "does not redirect to next step when postcode is invalid" do
      params["postcode"] = "AAA1 1AA"
      post :submit, params: params

      expect(response).to render_template(current_template)
    end

    it "removes extra whitespace from the postcode" do
      params["postcode"] = "E1 8QS "
      post :submit, params: params

      expect(response).to redirect_to(next_page)
      expect(session[session_key]["postcode"]).to eq("E1 8QS")
    end

    described_class::REQUIRED_FIELDS.each do |field|
      it "requires that key #{field} be provided" do
        post :submit, params: params.except(field)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(current_template)
      end
    end
  end
end
