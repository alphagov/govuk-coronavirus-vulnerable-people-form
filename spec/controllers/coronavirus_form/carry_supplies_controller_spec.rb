# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::CarrySuppliesController, type: :controller do
  let(:current_template) { "coronavirus_form/carry_supplies" }
  let(:session_key) { :carry_supplies }

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
      I18n.t("coronavirus_form.questions.carry_supplies.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { carry_supplies: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { carry_supplies: "" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { carry_supplies: selected }
      expect(response).to redirect_to(check_your_answers_path)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { carry_supplies: "<script></script>" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { carry_supplies: selected }

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
