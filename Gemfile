# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = "0.27.2"

gem 'decidim', DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
# Read more: https://github.com/mainio/decidim-module-term_customizer
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "master"
# TODO: support 0.27
# gem "decidim-verify_wo_registration", git: "https://github.com/PopulateTools/decidim-verify_wo_registration.git", branch: "improve-ui-texts"
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome.git", branch: "main"

gem 'virtus-multiparams'
gem 'doorkeeper', '5.5.4'

gem 'faker'
gem 'puma'
gem 'uglifier'
gem "progressbar"

# Performance
gem "appsignal"

# Fixes an error with Ruby 3.1.2 and Psych 4.0.0
gem "psych", "< 4"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'decidim-dev', DECIDIM_VERSION
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
end

group :production, :staging do
  gem 'dalli'
  gem 'sendgrid-ruby'
  gem 'sidekiq', '~> 6.5', '>= 6.5.7'
  gem 'fog-aws'
  gem "aws-sdk-s3", require: false
  # security fix for excon gem, which is a fog-aws dependency
  gem 'excon', '>= 0.71.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
end
