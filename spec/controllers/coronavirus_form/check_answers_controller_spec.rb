# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::CheckAnswersController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/check_answers" }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = "Yes"

      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    before do
      @time = Time.zone.local(2020, 11, 1, 3, 3, 3)
      allow_any_instance_of(described_class).to receive(:reference_number).and_return("abc")
      allow_any_instance_of(ActiveSupport::TimeZone).to receive(:now).and_return(@time)
    end

    it "saves the form response to the database" do
      session[:attribute] = "key"
      post :submit

      expect(FormResponse.first).to have_attributes(
        ReferenceId: "abc",
        UnixTimestamp: @time,
        FormResponse: { "attribute": "key", "reference_id": "abc" },
      )
    end

    it "resets session" do
      post :submit
      expect(session.to_hash).to eq({})
    end

    it "redirects to thank you if sucessfully creates record" do
      post :submit

      expect(response).to redirect_to({
        controller: "confirmation",
        action: "show",
        params: { reference_number: "abc" },
      })
    end

    it "replaces medical conditions listed response with legacy answer" do
      session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_medical.label")

      post :submit

      expect(FormResponse.last.attributes.dig(:FormResponse, :medical_conditions)).to eq("Yes, I have one of the medical conditions on the list")
    end

    it "replaces medical conditions GP response with legacy answer" do
      session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_gp.label")

      post :submit

      expect(FormResponse.last.attributes.dig(:FormResponse, :medical_conditions)).to eq("Yes, I have one of the medical conditions on the list")
    end

    it "doesn't create a FormResponse if the user is the smoke tester" do
      session[:contact_details] = { email: Rails.application.config.courtesy_copy_email }
      session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_gp.label")

      expect {
        post :submit
      }.to_not(change { FormResponse.count })
    end
  end
end
