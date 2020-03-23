# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::MedicalConditionsController, type: :controller do
  let(:current_template) { "coronavirus_form/medical_conditions" }
  let(:session_key) { :medical_conditions }

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
      I18n.t("coronavirus_form.questions.medical_conditions.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { medical_conditions: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { medical_conditions: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a yes response" do
      post :submit, params: { medical_conditions: I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes.label") }
      expect(response).to redirect_to(know_nhs_number_path)
    end

    it "redirects to ineligible page for a no response" do
      post :submit, params: { medical_conditions: I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label") }
      expect(response).to redirect_to(not_eligible_medical_path)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { medical_conditions: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { medical_conditions: I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes.label") }

      expect(response).to redirect_to(check_your_answers_path)
    end

    it "redirects to ineligible page for a no response when check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { medical_conditions: I18n.t("coronavirus_form.questions.medical_conditions.options.option_no.label") }

      expect(response).to redirect_to(not_eligible_medical_path)
    end
  end
end
