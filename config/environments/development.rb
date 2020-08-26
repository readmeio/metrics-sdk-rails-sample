require "readme/metrics"

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :local
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  ## Configure middleware

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
