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
      get "/metrics"

      expect(last_response).to be_ok
    end
  end
end
