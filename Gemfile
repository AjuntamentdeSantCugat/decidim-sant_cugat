source "https://rubygems.org"

ruby '2.5.3'

gem "decidim", "~> 0.15.0"

gem "virtus-multiparams"

gem 'uglifier'
gem 'faker'

group :development, :test do
  gem 'byebug', platform: :mri
  gem "decidim-dev"
  gem "puma"
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'passenger'
  gem 'fog-aws'
  gem 'dalli'
  gem 'sendgrid-ruby'
  gem 'newrelic_rpm'
  gem 'lograge'
  gem 'sentry-raven'
  gem 'sidekiq'
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end
