# frozen_string_literal: true

test_url = ENV["TEST_URL"]
if test_url.nil?
  require "cucumber/rails"
  ActionController::Base.allow_rescue = false
else
  require "capybara/apparition"
  require "capybara/cucumber"
  require "capybara/rspec"
  Capybara.default_driver = :apparition
  Capybara.app_host = test_url
end

Capybara.configure do |config|
  config.automatic_label_click = true
end
