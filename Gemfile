# frozen_string_literal: true

ruby File.read('.ruby-version').strip

source 'https://rubygems.org'

gem 'rails', '~> 6.0.2'

gem 'bootsnap', '~> 1'
gem 'govuk_app_config', '~> 2.1.1'
gem 'govuk_publishing_components', '~> 21.29.1'
gem 'pg', '~> 1'
gem "puma", "~> 4.3"
gem 'uglifier', '~> 4.2'

group :development do
  gem 'listen', '~> 3'
end

group :test do
  gem 'simplecov', '~> 0.16'
end

group :development, :test do
  gem 'byebug', '~> 10'
  gem "foreman", "~> 0.87.0"
  gem 'rspec-rails', '~> 3'
  gem 'rubocop-govuk'
end
