require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"

Bundler.require(*Rails.groups)

module ReadmeRailsSample
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true

    require "readme/metrics"

    options = {
      api_key: ENV.fetch("METRICS_API_KEY"),
      development: true,
      buffer_length: 1,
    }

    config.middleware.insert_before 0, Rack::ContentLength
    config.middleware.use Readme::Metrics, options do |env|
      current_user = env['warden'].authenticate

      if current_user.present?
        {
          id: current_user.id,
          label: current_user.name,
          email: current_user.email
        }
      else
        {
          id: "Sample Rails Application",
          label: "Guest",
          email: "guest@example.com"
        }
      end
    end
  end
end
