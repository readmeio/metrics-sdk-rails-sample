require "readme/metrics"

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_storage.service = :local
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  ## Configure middleware

  options = { api_key: ENV.fetch("METRICS_API_KEY") }

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
