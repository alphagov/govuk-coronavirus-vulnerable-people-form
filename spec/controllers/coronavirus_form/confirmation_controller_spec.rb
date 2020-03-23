# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::ConfirmationController, type: :controller do
  let(:current_template) { "coronavirus_form/confirmation" }

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
end
