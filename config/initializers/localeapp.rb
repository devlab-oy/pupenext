unless Rails.env.production?
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = Rails.application.secrets.localeapp_api_key
    config.sending_environments = [] # Never send missing keys
    config.polling_environments = [] # Never poll for missing keys
  end
end
