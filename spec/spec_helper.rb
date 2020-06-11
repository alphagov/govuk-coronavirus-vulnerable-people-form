# typed: false
# frozen_string_literal: true

require "byebug"
require "simplecov"
require "simplecov-cobertura"
require "capybara/rspec"
require "capybara/apparition"
require "vcr"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)
VCR.turn_off!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

Capybara.javascript_driver = :apparition

RSpec.configure do |config|
  if ENV["RAILS_ENV"] == "smoke_test"
    config.use_active_record = false
  else
    config.expose_dsl_globally = false
    config.infer_spec_type_from_file_location!
    config.use_transactional_fixtures = true

    config.before(:each) do
      DynamoidReset.all
    end
  end
end
