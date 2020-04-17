# frozen_string_literal: true

require "capybara/apparition"
require "capybara/rspec"

test_url = ENV["TEST_URL"]

Capybara.register_driver :apparition do |app|
  options = { browser_options: {}, timeout: 10, skip_image_loading: true }
  if ENV.key? "CHROME_NO_SANDBOX"
    options[:browser_options]["no-sandbox"] = true
  end
  Capybara::Apparition::Driver.new(app, options)
end

Capybara.javascript_driver = :apparition
Capybara.default_max_wait_time = 10
Capybara.exact = true
Capybara.match = :one

Capybara.configure do |config|
  config.automatic_label_click = true
end

if test_url
  Capybara.default_driver = Capybara.javascript_driver
  Capybara.app_host = test_url
  Capybara.run_server = false
else
  Capybara.server = :puma, { Silent: true }
end

Capybara.use_default_driver
