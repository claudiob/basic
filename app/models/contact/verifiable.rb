# Extends Contact with PIN-based phone verification.
module Contact::Verifiable extend ActiveSupport::Concern
  # The number every code is texted from.
  SENDER = ENV['TWILIO_PHONE']

  included do
    validates :pin, confirmation: true
    performs :text_pin
    after_update_commit :text_pin_later, if: :pin_previously_changed?
  end

  # Generates and persists a new random 6-digit PIN, which texts it to the number.
  def generate_pin = update pin: format('%06d', SecureRandom.random_number(10**6))

private

  def text_pin
    host = Rails.application.default_url_options[:host]
    Twi.create_message sender: SENDER, recipient: phone, content: I18n.t('contact.pin', pin:, host:)
  end
end
