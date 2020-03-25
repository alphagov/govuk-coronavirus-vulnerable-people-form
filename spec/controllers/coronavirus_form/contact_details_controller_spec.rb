# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::ContactDetailsController, type: :controller do
  include_examples "redirections"

  let(:current_template) { "coronavirus_form/contact_details" }
  let(:session_key) { :contact_details }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = "Yes"

      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        "phone_number_calls" => "1234",
        "phone_number_texts" => "5678",
        "email" => "somewhere@somewhere.com",
      }
    end

    it "sets session variables" do
      post :submit, params: params
      expect(session[session_key]).to eq params
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: params
      expect(response).to redirect_to(medical_conditions_path)
    end

    it "does not move to next step with an invalid email address" do
      post :submit, params: { email: "not-a-valid-email" }
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
