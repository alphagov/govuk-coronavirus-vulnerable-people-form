# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::HotelRoomsController, type: :controller do
  let(:current_template) { "coronavirus_form/hotel_rooms" }
  let(:session_key) { :hotel_rooms }

  describe "GET show" do
    it "renders the form" do
      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:selected) { permitted_values.sample }
    let(:permitted_values) do
      I18n.t("coronavirus_form.hotel_rooms.options").map { |_, item| item[:label] }
    end

    it "sets session variables" do
      post :submit, params: { hotel_rooms: selected }
      expect(session[session_key]).to eq selected
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: { hotel_rooms: selected }
      expect(response).to redirect_to(coronavirus_form_offer_food_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: { hotel_rooms: selected }

      expect(response).to redirect_to(coronavirus_form_check_your_answers_path)
    end

    it "validates any option is chosen" do
      post :submit, params: { hotel_rooms: "" }

      expect(response).to render_template(current_template)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { hotel_rooms: "<script></script>" }

      expect(response).to render_template(current_template)
    end
  end
end
