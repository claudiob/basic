Rails.application.default_url_options = { host: '0.0.0.0' }

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV['CI'].present?
  config.public_file_server.headers = { 'cache-control' => 'public, max-age=3600' }
  config.consider_all_requests_local = true
  config.cache_store = :memory_store
  config.action_dispatch.show_exceptions = :rescuable
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr
  config.active_record.encryption.encrypt_fixtures = true
  config.action_controller.raise_on_missing_callback_actions = true

  # A job runs inside the request or test that asked for it, however far ahead.
  config.active_job.queue_adapter = :immediate
end
