# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::VirusTestController, type: :controller do
  let(:current_template) { "coronavirus_form/virus_test" }
  let(:session_key) { :virus_test }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.virus_test.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { virus_test: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { virus_test: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { virus_test: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { virus_test: selected }
      expect(response).to redirect_to(coronavirus_form_check_your_answers_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { virus_test: selected }

      expect(response).to redirect_to(coronavirus_form_check_your_answers_path)
    end
  end
end
