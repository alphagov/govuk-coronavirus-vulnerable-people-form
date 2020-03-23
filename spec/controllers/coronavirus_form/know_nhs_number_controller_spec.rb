# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::KnowNhsNumberController, type: :controller do
  let(:current_template) { "coronavirus_form/know_nhs_number" }
  let(:session_key) { :know_nhs_number }

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
      I18n.t("coronavirus_form.questions.know_nhs_number.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { know_nhs_number: selected }
      expect(session[session_key]).to eq selected
    end

    it "validates any option is chosen" do
      post :submit, params: { know_nhs_number: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { know_nhs_number: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: {
        know_nhs_number: I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label"),
      }

      expect(response).to redirect_to(nhs_number_path)
    end

    it "redirects to what is your NHS number question if check your answers previously seen and answer to question is yes" do
      session[:check_answers_seen] = true
      post :submit, params: {
        know_nhs_number: I18n.t("coronavirus_form.questions.know_nhs_number.options.option_yes.label"),
      }

      expect(response).to redirect_to(nhs_number_path)
    end

    it "redirects to check your answers if check your answers previously seen and answer to question is no" do
      session[:check_answers_seen] = true
      post :submit, params: {
        know_nhs_number: I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label"),
      }
      expect(response).to redirect_to(check_your_answers_path)
    end

    it "clears the nhs_number if the user changes their answer to No" do
      session[:nhs_number] = "485 777 3456"

      post :submit, params: {
        know_nhs_number: I18n.t("coronavirus_form.questions.know_nhs_number.options.option_no.label"),
      }

      expect(session[:nhs_number]).to be_nil
    end
  end
end
