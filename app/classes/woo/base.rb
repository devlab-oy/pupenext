require 'woocommerce_api'

class Woo::Base
  attr_reader :logger, :woocommerce

  def initialize(company_id:, **_)
    raise ArgumentError, 'WooCommerce ENV variables missing' unless valid_configuration?

    Current.company = Company.find(company_id)

    @logger = Logger.new(STDOUT) # Rails.env.production?
    @woocommerce = WooCommerce::API.new(
      store_url,
      consumer_key,
      consumer_secret,
      wp_api: true,
      version: 'wc/v1',
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

    def woo_get(uri, data = {})
      response = woocommerce.get(uri, data)

      parse_response response
    end

    def woo_post(uri, data = {})
      response = woocommerce.post(uri, data)

      parse_response response
    end

    def woo_put(uri, data = {})
      response = woocommerce.put(uri, data)

      parse_response response
    end

  private

    def parse_response(response)
      return response.parsed_response if response.success?

      logger.error response.message

      nil
    end
end
