require 'woocommerce_api'

class Woo::Base
  def initialize
    raise(ArgumentError, "WooCommerce ENV variables missing") unless(valid_configuration?)

    @logger = Logger.new(STDOUT) # Rails.env.production?
    @woocommerce = WooCommerce::API.new(
      Rails.application.secrets.woocommerce_store_url,
      Rails.application.secrets.woocommerce_consumer_key,
      Rails.application.secrets.woocommerce_consumer_secret,
      {
        wp_api: true,
        version: 'wc/v1'
      }
    )
  end

  protected

    def logger
      @logger
    end

    def valid_configuration?
      Rails.application.secrets.woocommerce_store_url.present? && Rails.application.secrets.woocommerce_consumer_key.present? && Rails.application.secrets.woocommerce_consumer_secret.present?
    end
end
