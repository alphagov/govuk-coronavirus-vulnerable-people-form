# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::NameController, type: :controller do
  include_examples "redirections"
  include_examples "session expiry"

  let(:current_template) { "coronavirus_form/name" }
  let(:session_key) { :name }

  describe "GET show" do
    it "renders the form" do
      session[:live_in_england] = I18n.t("coronavirus_form.questions.live_in_england.options.option_yes.label")

      get :show
      expect(response).to render_template(current_template)
    end
  end

  describe "POST submit" do
    let(:params) do
      {
        "first_name" => "Harry<script></script>",
        "middle_name" => "Snape<script></script>",
        "last_name" => "<script></script>Potter",
      }
    end
    let(:person) do
      {
        first_name: "Harry",
        middle_name: "Snape",
        last_name: "Potter",
      }
    end


    it "sets session variables as sanitize symbolized keys" do
      post :submit, params: params
      expect(session[session_key]).to eq person
    end

    it "strips html characters" do
      params = {
        "first_name" => '<a href="https://www.example.com">Link</a>',
        "middle_name" => '<a href="https://www.example.com">Link</a>',
        "last_name" => '<a href="https://www.example.com">Link</a>',
      }

      name = {
        first_name: "Link",
        middle_name: "Link",
        last_name: "Link",
      }

      post :submit, params: params
      expect(session[session_key]).to eq name
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

      expect(session[session_key]).to eq person.merge(middle_name: nil)
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
