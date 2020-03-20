# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::WhichServicesController, type: :controller do
  let(:current_template) { "coronavirus_form/which_services" }
  let(:session_key) { :which_services }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { %w[Transport Consultancy] }

    it "sets session variables" do
      post :submit, params: { which_services: selected }

      expect(session[session_key]).to eq selected
    end

    it "redirects to next step" do
      post :submit, params: { which_services: selected }

      expect(response).to redirect_to("/coronavirus-form/thank-you")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { which_services: selected }

      expect(response).to redirect_to("/coronavirus-form/check-your-answers")
    end

    it "validates any option is chosen" do
      post :submit, params: { which_services: [] }

      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { which_services: ["<script></script", "invalid option", "Transport"] }

      expect(response).to render_template(current_template)
    end
  end
end
