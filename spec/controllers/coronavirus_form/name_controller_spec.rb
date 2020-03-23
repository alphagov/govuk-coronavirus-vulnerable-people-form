# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::NameController, type: :controller do
  let(:current_template) { "coronavirus_form/name" }
  let(:session_key) { :name }

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

  describe "POST submit" do
    let(:params) do
      {
        "first_name" => "Harry",
        "middle_name" => "Snape",
        "last_name" => "Potter",
      }
    end
    let(:person) do
      {
        "first_name" => "Harry",
        "middle_name" => "Snape",
        "last_name" => "Potter",
      }
    end


    it "sets session variables" do
      post :submit, params: params
      expect(session[session_key]).to eq person
    end

    %w(first_name last_name).each do |field|
      it "validates #{field} is required" do
        post :submit, params: params.except(field)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(current_template)
      end

      it "validates a value for #{field} is required" do
        post :submit, params: params.merge(field => "")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(current_template)
      end
    end

    it "validates middle name is not required" do
      post :submit, params: params.except("middle_name")

      expect(session[session_key]).to eq person.merge("middle_name" => nil)
      expect(response).to redirect_to(date_of_birth_path)
    end

    it "validates a valid option is chosen" do
      post :submit, params: { first_name: "<script></script>" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to render_template(current_template)
    end

    it "redirects to next step for a permitted response" do
      post :submit, params: params
      expect(response).to redirect_to(date_of_birth_path)
    end

    it "redirects to check your answers if check your answers previously seen" do
      session[:check_answers_seen] = true
      post :submit, params: params

      expect(response).to redirect_to(check_your_answers_path)
    end
  end
end
