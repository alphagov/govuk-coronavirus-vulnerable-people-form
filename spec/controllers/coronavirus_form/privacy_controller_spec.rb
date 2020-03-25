# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::PrivacyController, type: :controller do
  let(:current_template) { "coronavirus_form/privacy" }

  describe "GET show" do
    it "renders the page" do
      get :show
      expect(response).to render_template(current_template)
    end
  end
end
