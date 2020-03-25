# frozen_string_literal: true

if ENV.key? "TEST_URL"
  require "capybara/apparition"
  require "capybara/cucumber"
  require "capybara/rspec"
  Capybara.default_driver = :apparition
else
  require "cucumber/rails"
  ActionController::Base.allow_rescue = false
end

Capybara.configure do |config|
  config.automatic_label_click = true
end
