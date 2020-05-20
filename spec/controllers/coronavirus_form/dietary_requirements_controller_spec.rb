# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::DietaryRequirementsController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/dietary_requirements" }
  let(:session_key) { :dietary_requirements }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")

      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.questions.dietary_requirements.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { dietary_requirements: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { dietary_requirements: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { dietary_requirements: selected }
      expect(response).to redirect_to(carry_supplies_path)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { dietary_requirements: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to to next question if check your answers previously seen and later food question not answered" do
      session[:check_answers_seen] = true
      post :submit, params: { dietary_requirements: selected }

      expect(response).to redirect_to(carry_supplies_path)
    end

    it "redirects to check your answers if check your answers previously seen and later food question answered" do
      session[:check_answers_seen] = true
      session[:carry_supplies] = "Yes"
      post :submit, params: { dietary_requirements: selected }

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
