# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 6.0.3"

gem "asset_sync"
gem "bootsnap", "~> 1"
gem "dynamoid"
gem "faraday", "~> 1.0.1"
gem "fog-aws"
gem "govuk_app_config", "~> 2.1.1"
gem "govuk_publishing_components", "~> 21.45.0"
gem "lograge"
gem "notifications-ruby-client", "~> 5.1"
gem "puma", "~> 4.3"
gem "sass-rails", "< 6"
gem "sentry-raven", "~> 3.0"
gem "sidekiq", "~> 6.0"
gem "telephone_number", "~> 1.4"
gem "timecop"
gem "uglifier", "~> 4.2"

gem "prometheus-client", "~> 2.0"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "apparition", "~> 0.5.0", require: false
  gem "capybara", "~> 3.32.1", require: false
  gem "climate_control"
  gem "mini_racer", "~> 0.2"
  gem "scss-lint", "~> 0.7.0", require: false
  gem "selenium-webdriver"
  gem "simplecov", "~> 0.16"
  gem "vcr"
  gem "webdrivers"
  gem "webmock"
end

group :development, :test do
  gem "awesome_print", "~> 1.8"
  gem "byebug", "~> 11"
  gem "foreman", "~> 0.87.1"
  gem "pry", "~> 0.13.1"
  gem "pry-rails", "~> 0.3.9"
  gem "rails-controller-testing", "~> 1.0"
  gem "rspec-rails", "~> 4.0.0"
  gem "rubocop-govuk"
end

gem "omniauth", "~> 1.9"

gem "openid_connect", "~> 1.2"
