# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.6'

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim.git", branch: "release/0.27-stable" }.freeze

gem 'decidim', DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
# Read more: https://github.com/mainio/decidim-module-term_customizer
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer.git", branch: "release/0.27-stable"
# verify_wo_registration module is prepared to 0.28 in master and includes the
# code of improve-ui-texts of the PopulateTools fork. Uncomment this after the
# upgrade to 0.28
# gem "decidim-verify_wo_registration", git: "https://github.com/CodiTramuntana/decidim-verify_wo_registration.git", branch: "master"
gem "decidim-decidim_awesome"

gem 'virtus-multiparams'
gem 'doorkeeper', '5.5.4'

gem 'faker'
gem 'puma'
gem 'uglifier'
gem "progressbar"

# Performance
gem "appsignal", "= 3.0.6"

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
