require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

# Basic: people sign in with their mobile number, and admins with Google.
module Basic
  # The Rails application and its configuration.
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib ignore: %w[assets tasks]
    config.generators.test_framework nil
    config.time_zone = 'Eastern Time (US & Canada)'

    # Marks a rejected field the way Bootstrap expects, with its message beside it.
    config.action_view.field_error_proc = proc do |html_tag, instance|
      # A label or any other tag without a control class falls through unmarked.
      if (control = html_tag.index('form-control') || html_tag.index('otp-input'))
        id = SecureRandom.hex
        html_tag.insert control, 'is-invalid '
        html_tag.insert html_tag.index(' '), " aria-describedby=#{id}"
        ("#{html_tag}<small class='invalid-feedback' id='#{id}'>" \
         "#{instance.error_message.to_sentence}</small>").html_safe
      else
        html_tag
      end
    end
  end
end
