require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ontime1
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.days_to_confirm_invite_email = 7
    config.working_day_start_time = "9:00"
    config.working_day_end_time = "18:00"

    config.super_admin_name = "Super admin"
    config.admin_name = "Administrator"
    config.user_name = "User"
    config.client_name = "Client"

    config.default_time_zone = "UTC"

    config.encryption_salt = "?\x118\x11\a\xCBt\xA3\xB5\x93}w\x01C\xCDk\xC3\xECX\xC4\xB0\xB8\xD5\x8A\\\xA79\xD0\xC7i\r'"
    config.encryption_key_length=32

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
