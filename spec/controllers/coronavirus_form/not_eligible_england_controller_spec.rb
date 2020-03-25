# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::NotEligibleEnglandController, type: :controller do
  include_examples "redirections"

  let(:current_template) { "coronavirus_form/not_eligible_england" }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = "Yes"

      get :show
      expect(response).to render_template(current_template)
    end
  end
end
