# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

# Adds safeguards to prevent dangerous database migrations
gem 'strong_migrations', '~> 2.0'

# Provides authentication solutions for Rails applications
gem 'devise', '~> 4.9', '>= 4.9.4'

# An HTML, XML, SAX, and Reader parser with XPath and CSS selector support
gem 'nokogiri', '~> 1.16', '>= 1.16.7'

# A Ruby library for reading and writing ZIP files
gem 'rubyzip', '~> 2.3', '>= 2.3.2'

# Background job processing for Ruby
gem 'sidekiq', '~> 7.3', '>= 7.3.1'

# A gem for generating Excel files (XLSX)
gem 'caxlsx', '~> 4.1'

# Process manager for applications with multiple components
gem 'foreman', '~> 0.88.1'

gem 'aws-sdk'

group :development, :test do
  # Gem to generate valid CPF and CNPJ for testing purposes
  gem 'cpf_cnpj', '~> 0.5.0'

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]

  # Factory bot for setting up Ruby objects as test data
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'

  # Faker gem to generate fake data for testing and development
  gem 'faker', '~> 3.4', '>= 3.4.2'

  # Debugging tool for the Rails console
  gem 'pry-rails', '~> 0.3.11'

  # Testing framework for creating and running tests
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.5'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.3'
  gem 'rspec-sidekiq', '~> 5.0'

  # Gems for code quality, performance improvements, and adherence to Rails standards
  gem 'rubocop', '~> 1.65', '>= 1.65.1'
  gem 'rubocop-performance', '~> 1.21', '>= 1.21.1'
  gem 'rubocop-rails', '~> 2.25', '>= 2.25.1'
  gem 'rubocop-rspec', '~> 3.0', '>= 3.0.4'

  # Provides additional matchers for testing with RSpec
  gem 'shoulda-matchers', '~> 6.3', '>= 6.3.1'

  # Code coverage analysis tool for measuring test coverage
  gem 'simplecov', '~> 0.22.0'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
