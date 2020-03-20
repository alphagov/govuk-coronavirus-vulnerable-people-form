# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AdditionalProductCheckController, type: :controller do
  let(:current_template) { "coronavirus_form/additional_product_check" }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    it "redirects to next step for yes response" do
      post :submit, params: { additional_product_check: "Yes" }
      expect(response).to redirect_to(coronavirus_form_product_details_path)
    end

    it "redirects to next sub-question for no response" do
      post :submit, params: { additional_product_check: "No" }

      expect(response).to redirect_to(coronavirus_form_thank_you_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { additional_product_check: "Yes" }

      expect(response).to redirect_to("/coronavirus-form/check-your-answers")
    end

    it "validates any option is chosen" do
      post :submit, params: { additional_product_check: "" }

      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { additional_product_check: "<script></script>" }

      expect(response).to render_template(current_template)
    end
  end
end
