require 'active_support/core_ext/integer/time'

Rails.application.default_url_options = { host: ENV['DEFAULT_URL_HOST'] }

Rails.application.configure do
  config.active_record.encryption.primary_key = ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY']
  config.active_record.encryption.deterministic_key = ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY']
  config.active_record.encryption.key_derivation_salt = ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT']
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { 'cache-control' => "public, max-age=#{1.year.to_i}" }
  config.assume_ssl = true
  config.force_ssl = true
  config.log_tags = [ lambda { |request| request.uuid.first(8) } ]
  config.logger   = ActiveSupport::TaggedLogging.logger STDOUT
  config.action_view.logger = nil
  config.log_level = ENV.fetch 'RAILS_LOG_LEVEL', 'info'
  config.silence_healthcheck_path = '/up'
  config.active_support.report_deprecations = false
  config.cache_store = :redis_cache_store, {
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'),
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  }
  config.active_job.queue_adapter = :sidekiq
  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
  config.hosts = Array(ENV['DEFAULT_URL_HOST'])
end
