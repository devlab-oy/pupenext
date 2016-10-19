require "woocommerce_api"

class Woo::Base
  def initialize
    @woocommerce = WooCommerce::API.new(
      "http://dev.flowcosmetics.com",
      Rails.application.secrets.woocommerce_consumer_key,
      Rails.application.secrets.woocommerce_consumer_secret,
      {
        wp_api: true,
        version: "wc/v1"
      }
    )
  end
end
