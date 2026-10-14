# Uses Yt.configuration.mock_auth_email to stub any HTTP request to sign in with Google.
module GoogleStubs extend ActiveSupport::Concern
  included do
    setup { Yt.configuration.mock_auth_email = 'agent@example.com' }
  end
end
