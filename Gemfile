# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 6.0.3"

gem "asset_sync"
gem "aws-sdk-s3", "~> 1.74"
gem "bootsnap", "~> 1"
gem "dynamoid"
gem "faraday", "~> 1.0.1"
gem "fog-aws"
gem "govuk_app_config", "~> 2.4.0"
gem "govuk_publishing_components", "~> 23.9.1"
gem "json_schemer", "~> 0.2"
gem "lograge"
gem "mailcheck", "~> 1.0"
gem "notifications-ruby-client", "~> 5.1"
gem "prometheus-client", "~> 2.1"
gem "puma", "~> 4.3"
gem "sass-rails", "< 6"
gem "sentry-raven", "~> 3.0"
gem "sidekiq", "~> 6.1"
gem "simplecov-cobertura"
gem "telephone_number", "~> 1.4"
gem "timecop"
gem "uglifier", "~> 4.2"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "apparition", "~> 0.6.0", require: false
  gem "capybara", "~> 3.33.0", require: false
  gem "mini_racer", "~> 0.2"
  gem "selenium-webdriver"
  gem "simplecov", "~> 0.16"
  gem "vcr"
  gem "webdrivers"
  gem "webmock"
end

group :development, :test do
  gem "awesome_print", "~> 1.8"
  gem "brakeman", "~> 4.9"
  gem "byebug", "~> 11"
  gem "foreman", "~> 0.87.1"
  gem "govuk_test", "~> 2.1"
  gem "jasmine", "~> 3.6"
  gem "jasmine_selenium_runner", require: false
  gem "pry", "~> 0.13.1"
  gem "pry-rails", "~> 0.3.9"
  gem "rails-controller-testing", "~> 1.0"
  gem "rspec-rails", "~> 4.0.1"
  gem "rubocop-govuk"
  gem "scss_lint-govuk"
end
