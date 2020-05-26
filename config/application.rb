# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"]
  config.before_send = lambda { |event, _hint|
    if event.extra.dig(:sidekiq, :job, :args, :arguments)
      event.extra[:sidekiq][:job][:args][:arguments] = []
    end
    if event.extra.dig(:sidekiq, :jobstr)
      event.extra[:sidekiq][:jobstr] = {}
    end
    event
  }
end

module CoronavirusForm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.courtesy_copy_email = "coronavirus-services-smoke-tests@digital.cabinet-office.gov.uk"
    config.test_telephone_number = "01234567890"

    config.active_job.queue_adapter = :sidekiq

    # Don't generate system test files.
    config.generators.system_tests = nil

    unless Rails.env.production?
      ENV["ORDNANCE_SURVEY_PLACES_API_KEY"] = "123"
    end
  end
end
