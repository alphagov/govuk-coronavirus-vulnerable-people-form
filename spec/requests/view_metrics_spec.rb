require_relative "../../helpers/application_config"
require "rack/test"
require "spec_helper"

RSpec.describe "prometheus metrics", type: :request do
  include Rack::Test::Methods

  rack_app = ApplicationConfig.call

  let(:app) do
    rack_app
  end

  context "when requesting app endpoints" do
    it "returns ok response" do
      username = Rails.application.config.metrics_username
      password = Rails.application.config.metrics_password

      get "/metrics", {}, { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password) }

      expect(last_response).to be_ok
    end

    it "returns forbidden response without authentication" do
      get "/metrics"

      expect(last_response).not_to be_ok
      expect(last_response.status).to eq(401)
    end
  end
end
