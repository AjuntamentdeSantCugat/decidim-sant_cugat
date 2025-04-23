require_relative 'boot'

require "decidim/rails"
require "action_cable/engine"
require 'fog/aws'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DecidimSantCugat
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Locales
    config.i18n.available_locales = %w(ca)
    config.i18n.default_locale = :ca

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

Decidim.configure do |config|
  # Max requests in a time period to prevent DoS attacks. Only applied on production.
  config.throttling_max_requests = 1000

  # Time window in which the throttling is applied.
  # config.throttling_period = 1.minute
end
