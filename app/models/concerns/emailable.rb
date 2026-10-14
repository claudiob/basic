# Extends any model with an email attribute to store it trimmed and lowercase, and blank as nil.
module Emailable extend ActiveSupport::Concern
  included do
    normalizes :email, with: ->(email) { email.strip.downcase.presence }
  end
end
