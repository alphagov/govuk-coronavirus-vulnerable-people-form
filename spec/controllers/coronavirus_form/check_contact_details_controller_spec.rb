# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::CheckContactDetailsController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/check_contact_details" }

  let(:existing_contact_details) do
    {
      phone_number_calls: "01234-578-890",
      phone_number_texts: "01234-578-890",
      email: "me@example.com",
    }
  end

  before do
    session[:contact_details] = existing_contact_details
  end

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")

      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        "email" => "<script></script>tester@example.org",
      }
    end

    let(:contact_details) do
      {
        email: "tester@example.org",
      }
    end

    it "sets session variables as sanitize symbolized keys and does not overwrite existing phone values" do
      post :submit, params: params
      expect(session[:contact_details]).to eq existing_contact_details.merge(contact_details)
    end

    context "session[:contact_details] is unset" do
      before do
        session[:contact_details] = nil
      end

      it "sets the new session variables successfully" do
        post :submit, params: params
        expect(session[:contact_details]).to eq contact_details
      end
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: params
      expect(response).to redirect_to essential_supplies_path
    end

    it "does not move to next step with an invalid email address" do
      post :submit, params: { "email": "govuk-coronavirus-services@digital.cabinet_office,gov.uk" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: params

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
