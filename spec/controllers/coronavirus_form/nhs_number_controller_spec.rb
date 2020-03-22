# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::NhsNumberController, type: :controller do
  let(:current_template) { "coronavirus_form/nhs_number" }
  let(:session_key) { :nhs_number }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    it "sets session variables" do
      post :submit, params: { nhs_number: "485 777 3456" }
      expect(session[session_key]).to eq "485 777 3456"
    end

    it "validates the nhs_number is required" do
      post :submit, params: {}

      expect(response).to render_template(current_template)
    end

    # it "validates a value is required for nhs_number" do
    #   post :submit, params: { "nhs_number" => "" }

    #   expect(response).to render_template(current_template)
    # end


    it "redirects to next step for a permitted response" do
      post :submit, params: { nhs_number: "485 777 3456" }
      expect(response).to redirect_to(coronavirus_form_check_your_answers_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { nhs_number: "485 777 3456" }

      expect(response).to redirect_to(coronavirus_form_check_your_answers_path)
    end
  end
end


