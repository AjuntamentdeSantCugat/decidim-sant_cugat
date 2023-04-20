# -*- coding: utf-8 -*-
# frozen_string_literal: true
Decidim.configure do |config|
  config.application_name = "Decidim Sant Cugat"
  config.mailer_sender    = Rails.env.production? ? "participacio@santcugat.cat" : "noreply@decidim-review-apps.populate.tools"
  config.maximum_attachment_size = 100.megabytes

  config.unconfirmed_access_for = 0.days

  # Uncomment this lines to set your preferred locales
  config.available_locales = %i{ca}
  config.default_locale = :ca

  # Geocoder configuration
  config.maps = {
    provider: :here,
    api_key: Rails.application.secrets.maps[:api_key],
    static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  }
  config.geocoder = {
    timeout: 5,
    units: :km
  }

  # Currency unit
  config.currency_unit = "€"

  # The number of reports which an object can receive before hiding it
  # config.max_reports_before_hiding = 3

  if ENV["HEROKU_APP_NAME"].present?
    config.base_uploads_path = ENV["HEROKU_APP_NAME"] + "/"
  end

  # Custom HTML Header snippets
  #
  # The most common use is to integrate third-party services that require some
  # extra JavaScript or CSS. Also, you can use it to add extra meta tags to the
  # HTML. Note that this will only be rendered in public pages, not in the admin
  # section.
  #
  # Before enabling this you should ensure that any tracking that might be done
  # is in accordance with the rules and regulations that apply to your
  # environment and usage scenarios. This feature also comes with the risk
  # that an organization's administrator injects malicious scripts to spy on or
  # take over user accounts.
  #
  config.enable_html_header_snippets = true

  # Set max requests
  config.throttling_max_requests = 500
end

Decidim::Verifications.register_workflow(:census_authorization_handler) do |auth|
  auth.form = "CensusAuthorizationHandler"
  auth.action_authorizer= "CensusActionAuthorizer"
  auth.options do |options|
    options.attribute :district_council, type: :string, required: false
    options.attribute :district, type: :string, required: false
  end
end

# API configuration
Rails.application.config.to_prepare do
  Decidim::Api::Schema.max_complexity = 5000
  Decidim::Api::Schema.max_depth = 50
end
