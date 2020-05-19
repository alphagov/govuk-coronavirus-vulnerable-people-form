# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::CheckAnswersController, type: :controller do
  include FormResponseHelper
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/check_answers" }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")

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

    context "when running as a Heroku preview app" do
      before do
        ENV["HEROKU_APP_NAME"] = "coronavirus-form-preview"
      end

      it "does not save the form response to the database" do
        expect { post :submit }.to_not(change { FormResponse.count })
      end
    end

    it "sends an email" do
      ActiveJob::Base.queue_adapter = :test
      session[:name] = {
        first_name: "John",
        last_name: "Smith",
      }
      session[:contact_details] = {
        email: "name@example.org",
      }

      expect {
        post :submit
      }.to have_enqueued_mail(CoronavirusFormMailer, :confirmation_email)
        .with(a_hash_including(first_name: "John", last_name: "Smith", reference_number: "abc"), "name@example.org").on_queue("mailers")
    end

    it "does not send an email when no email address provided" do
      ActiveJob::Base.queue_adapter = :test
      session[:contact_details] = {
        email: "",
      }

      expect {
        post :submit
      }.to have_enqueued_mail(CoronavirusFormMailer, :confirmation_email).on_queue("mailers").exactly(0).times
    end

    it "sends an text message" do
      ActiveJob::Base.queue_adapter = :test
      session[:contact_details] = {
        phone_number_texts: "07790 900000",
      }

      expect {
        post :submit
      }.to have_enqueued_mail(CoronavirusFormMailer, :confirmation_sms)
        .with(a_hash_including(reference_number: "abc"), "07790900000").on_queue("mailers")
    end

    it "does not send a text message when no phone number for texting is provided" do
      ActiveJob::Base.queue_adapter = :test
      session[:contact_details] = {
        phone_number_texts: "",
      }

      expect {
        post :submit
      }.to have_enqueued_mail(CoronavirusFormMailer, :confirmation_sms).on_queue("mailers").exactly(0).times
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

    it "doesn't create a FormResponse if the user is the smoke tester identidied by email" do
      session[:contact_details] = { email: Rails.application.config.courtesy_copy_email }
      session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_gp.label")

      expect {
        post :submit
      }.to_not(change { FormResponse.count })
    end

    it "doesn't create a FormResponse if the user is the smoke tester identidied by mobile telephone number" do
      session[:contact_details] = { phone_number_texts: Rails.application.config.test_telephone_number }
      session[:medical_conditions] = I18n.t("coronavirus_form.questions.medical_conditions.options.option_yes_gp.label")

      expect {
        post :submit
      }.to_not(change { FormResponse.count })
    end

    context "schema validation" do
      it "sends a notification to Sentry if the schema validation fails" do
        expect(GovukError).to receive(:notify)
        post :submit
      end

      it "does not send a notification to Sentry if the data is valid" do
        expect(GovukError).to_not receive(:notify)

        session.merge!(valid_data)
        post :submit
      end
    end
  end
end
