# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::MedicalConditionsController, type: :controller do
  let(:current_template) { "coronavirus_form/medical_conditions" }
  let(:session_key) { :medical_conditions }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.medical_conditions.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { medical_conditions: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { medical_conditions: "" }

      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { medical_conditions: selected }
      expect(response).to redirect_to(coronavirus_form_virus_test_path)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { medical_conditions: "<script></script>" }

      expect(response).to render_template(current_template)
    end
  end
end
