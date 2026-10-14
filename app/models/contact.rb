# A mobile number that signs in to Basic, and the person it belongs to.
class Contact < ApplicationRecord
  include ActiveSupport::NumberHelper, Emailable, Phonable, Recoursive, Searchable, Verifiable

  encrypts :email, :phone, deterministic: { fixed: false }, downcase: true
  encrypts :surname, deterministic: { fixed: false }

  validates :phone, presence: true, uniqueness: true

  validate(on: :update) { errors.add :phone, 'cannot be changed' if phone_changed? }

  # The contact's name, or their number where they gave none.
  def to_s = [ name, surname ].compact_blank.join(' ').presence || number_to_phone(phone)
end
