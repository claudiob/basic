Rails.application.config.filter_parameters += [
  :phone, :surname,
  :passw, :email, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn, :cvv, :cvc,
]
