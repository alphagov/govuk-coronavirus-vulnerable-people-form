# frozen_string_literal: true

test_url = ENV["TEST_URL"]
if test_url.nil?
  require "cucumber/rails"
  ActionController::Base.allow_rescue = false
else
  require "capybara/apparition"
  require "capybara/cucumber"
  require "capybara/rspec"

  Capybara.register_driver :apparition do |app|
    options = { browser_options: {} }
    if ENV.key? "CHROME_NO_SANDBOX"
      options[:browser_options]["no-sandbox"] = true
    end
    Capybara::Apparition::Driver.new(app, options)
  end

  Capybara.default_driver = :apparition
  Capybara.app_host = test_url
end

Capybara.configure do |config|
  config.automatic_label_click = true
end
