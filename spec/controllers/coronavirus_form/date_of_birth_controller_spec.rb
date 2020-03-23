# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::DateOfBirthController, type: :controller do
  let(:current_template) { "coronavirus_form/date_of_birth" }
  let(:session_key) { "date_of_birth" }

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
        "date_of_birth" => {
          "day" => "31",
          "month" => "1",
          "year" => "1980",
        },
      }
    end

    it "sets session variables" do
      post :submit, params: params
      expect(session[session_key]).to eq params["date_of_birth"]
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: params
      expect(response).to redirect_to(support_address_path)
    end

    context "params unset" do
      let(:params) { params.translate_values { |_value| nil } }
    end

    it "does not move to next step if a field is missing" do
      post :submit, params: { "date_of_birth" => { "day" => "31" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "does not move to next step with an invalid value" do
      post :submit, params: {
        "date_of_birth" => {
          "day" => "<script></script>31",
          "month" => "</script>123456789 not a number",
          "year" => "not a number",
        },
      }
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
