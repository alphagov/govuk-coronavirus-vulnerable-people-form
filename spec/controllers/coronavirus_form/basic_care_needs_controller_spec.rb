# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::BasicCareNeedsController, type: :controller do
  let(:current_template) { "coronavirus_form/basic_care_needs" }
  let(:session_key) { :basic_care_needs }

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
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.questions.basic_care_needs.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { basic_care_needs: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { basic_care_needs: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { basic_care_needs: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { basic_care_needs: selected }
      expect(response).to redirect_to(dietary_requirements_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { basic_care_needs: "Yes" }

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
