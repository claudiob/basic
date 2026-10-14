# Production signs in with the Google client in YT_CLIENT_ID and YT_CLIENT_SECRET.
Yt.configure do |config|
  config.mock_auth_email = 'admin@example.com' if Rails.env.development?
end
