require "woocommerce_api"

class Woo::Base
  def initialize
    @logger = Logger.new(STDOUT) # Rails.env.production?
    @woocommerce = WooCommerce::API.new(
      Rails.application.secrets.woocommerce_store_url,
      Rails.application.secrets.woocommerce_consumer_key,
      Rails.application.secrets.woocommerce_consumer_secret,
      {
        wp_api: true,
        version: "wc/v1"
      }
    )
  end

  protected

    def logger
      @logger
    end
end
