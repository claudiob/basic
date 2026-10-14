# Stub HTTP requests to Twilio.
module TwilioStubs extend ActiveSupport::Concern
  included do
    setup { Twi.reset_mock }
  end
end
