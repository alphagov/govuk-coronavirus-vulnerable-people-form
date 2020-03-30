# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::SessionExpiredController, type: :controller do
  let(:current_template) { "coronavirus_form/session_expired" }

  describe "GET show" do
    it "renders the page" do
      get :show
      expect(response).to render_template(current_template)
    end
  end
end
