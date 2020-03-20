# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::MedicalEquipmentController, type: :controller do
  let(:current_template) { "coronavirus_form/medical_equipment" }
  let(:session_key) { :medical_equipment }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    it "sets session variables" do
      post :submit, params: { medical_equipment: "Yes" }

      expect(session[session_key]).to eq "Yes"
    end

    it "redirects to next step for yes response" do
      post :submit, params: { medical_equipment: "Yes" }

      expect(response).to redirect_to("/coronavirus-form/what-kind-of-medical-equipment")
    end

    it "redirects to next sub-question for no response" do
      post :submit, params: { medical_equipment: "No" }

      expect(response).to redirect_to("/coronavirus-form/do-you-have-hotel-rooms-to-offer")
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { medical_equipment: "Yes" }

      expect(response).to redirect_to("/coronavirus-form/check-your-answers")
    end

    it "validates any option is chosen" do
      post :submit, params: { medical_equipment: "" }

      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { medical_equipment: "<script></script>" }

      expect(response).to render_template(current_template)
    end
  end
end
