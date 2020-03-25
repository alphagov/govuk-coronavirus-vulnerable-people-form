# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 6.0.2"

gem "bootsnap", "~> 1"
gem "dynamoid"
gem "govuk_app_config", "~> 2.1.1"
gem "govuk_publishing_components", "~> 21.31.0"
gem "log_formatter", "~> 0.8.2"
gem "puma", "~> 4.3"
gem "sass-rails", "< 6"
gem "sentry-raven", "~> 3.0"
gem "timecop"
gem "uglifier", "~> 4.2"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "cucumber-rails", "~> 2.0", require: false
  gem "scss-lint", "~> 0.7.0", require: false
  gem "simplecov", "~> 0.16"
  gem "therubyracer", "~> 0.12"
end

group :development, :test do
  gem "awesome_print", "~> 1.8"
  gem "byebug", "~> 11"
  gem "foreman", "~> 0.87.0"
  gem "pry", "~> 0.13.0"
  gem "pry-rails", "~> 0.3.9"
  gem "rails-controller-testing", "~> 1.0"
  gem "rspec-rails", "~> 4.0.0"
  gem "rubocop-govuk"
end
