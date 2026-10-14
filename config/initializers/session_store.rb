# Named outright, so renaming the application's module signs nobody out.
Rails.application.config.session_store :cookie_store, key: '_basic_session'
