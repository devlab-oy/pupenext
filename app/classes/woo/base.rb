require 'woocommerce_api'

class Woo::Base
  attr_reader :logger, :woocommerce

  def initialize(company_id:, orders_path: 'tmp/orders_path')
    raise ArgumentError, 'WooCommerce ENV variables missing' unless valid_configuration?

    Current.company = Company.find(company_id)

    @edi_orders_path = orders_path
    @logger = Logger.new(STDOUT) # Rails.env.production?
    @woocommerce = WooCommerce::API.new(
      store_url,
      consumer_key,
      consumer_secret,
      wp_api: true,
      version: 'wc/v1'
    )
  end

  protected

    def valid_configuration?
      store_url.present? && consumer_key.present? && consumer_secret.present?
    end

    def store_url
      Rails.application.secrets.woocommerce_store_url
    end

    def consumer_key
      Rails.application.secrets.woocommerce_consumer_key
    end

    def consumer_secret
      Rails.application.secrets.woocommerce_consumer_secret
    end
end
