# typed: false
# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::PostcodeLookupController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/postcode_lookup" }
  let(:session_key) { :support_address }
  let(:next_page) { address_lookup_path }

  describe "GET show" do
    it "renders the postcode form" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")

      get :show
      expect(response).to render_template(current_template)
    end

    it "renders a flash message" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")
      session[:flash] = "Testing"

      get :show
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    context "no postcode" do
      it "renders an error message if the postcode is not given" do
        post :submit, params: { "postcode" => "" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(current_template)
      end
    end

    context "with postcode" do
      it "redirects to the address lookup path" do
        post :submit, params: { "postcode" => "SW1A2AA" }

        expect(response).to redirect_to(address_lookup_path)
      end
    end

    context "with malformed postcode" do
      it "shows error message" do
        post :submit, params: { "postcode" => "FRED01" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(current_template)
      end
    end
  end
end
