# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.7.3'

# DECIDIM_VERSION = "0.25.0"
DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: 'as_migration_debug' }

gem 'decidim', DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
# Read more: https://github.com/mainio/decidim-module-term_customizer
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "develop"
gem "decidim-verify_wo_registration", git: "https://github.com/PopulateTools/decidim-verify_wo_registration.git", branch: "release/0.25"

gem 'virtus-multiparams'

gem 'faker'
gem 'puma'
gem 'uglifier'
gem "progressbar"

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
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'sendgrid-ruby'
  gem 'sentry-raven'
  gem 'sidekiq'
  gem 'fog-aws'
  gem "aws-sdk-s3", require: false
  # security fix for excon gem, which is a fog-aws dependency
  gem 'excon', '>= 0.71.0'
  gem 'rails_autoscale_agent'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
end
