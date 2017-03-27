require 'woocommerce_api'

class Woo::Base
  attr_reader :woocommerce

  def initialize(company_id:, store_url:, consumer_key:, consumer_secret:)
    Current.company = Company.find(company_id)

    @woocommerce = WooCommerce::API.new(
      store_url,
      consumer_key,
      consumer_secret,
      wp_api: true,
      version: 'wc/v1',
      query_string_auth: true
    )
  end

  protected

    def logger
      return @logger if @logger

      dir = '/home/devlab/logs'
      path = Dir.exist?(dir) ? dir : '/tmp'
      file = self.class.name.demodulize.downcase

      @logger = Logger.new("#{path}/woocommerce_#{file}.log")
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
