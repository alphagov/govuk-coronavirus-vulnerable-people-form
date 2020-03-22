# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::LiveInEnglandController, type: :controller do
  let(:current_template) { "coronavirus_form/live_in_england" }
  let(:session_key) { :live_in_england }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.questions.live_in_england.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { live_in_england: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { live_in_england: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { live_in_england: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a yes response" do
      post :submit, params: { live_in_england: "Yes" }
      expect(response).to redirect_to(nhs_letter_path)
    end

    it "redirects to ineligible page for a no response" do
      post :submit, params: { live_in_england: "No" }
      expect(response).to redirect_to(not_eligible_england_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { live_in_england: "Yes" }

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
