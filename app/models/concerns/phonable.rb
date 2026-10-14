# Extends any model with a phone attribute to store it digits-only.
module Phonable extend ActiveSupport::Concern
  # Ten digits whose area code and exchange start with 2-9, so no leading 0 or 1.
  NORTH_AMERICAN_PHONES = /\A[2-9]\d{2}[2-9]\d{6}\z/

  included do
    normalizes :phone, with: ->(phone) { phone.delete('^0-9').delete_prefix '1' }

    with_options format: { with: NORTH_AMERICAN_PHONES, message: 'is not a valid phone number' } do
      validates :phone, allow_nil: true
    end
  end
end
