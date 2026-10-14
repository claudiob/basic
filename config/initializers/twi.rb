# Outside production a text is kept by the mock rather than sent: the code is in contacts.pin.
Twi.reset_mock unless Rails.env.production?
