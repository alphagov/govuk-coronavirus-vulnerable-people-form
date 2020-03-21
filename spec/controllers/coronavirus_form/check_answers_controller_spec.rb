# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::CheckAnswersController, type: :controller do
  let(:current_template) { "coronavirus_form/check_answers" }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    before do
      allow_any_instance_of(described_class).to receive(:reference_number).and_return("abc")
    end

    it "saves the form response to the database" do
      session["attribute"] = "key"
      post :submit

      expect(FormResponse.first.form_response).to eq(
        [%w[attribute key], %w[reference_number abc]],
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
  end
end
