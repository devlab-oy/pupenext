require('open3')

module LegacyMethods
  LEGACY_API_DIR = "#{Rails.application.secrets.pupesoft_install_dir}/rajapinnat"

  def self.customer_price(customer_id, product_id)
    price = discount_price('asiakas', customer_id, product_id)
    price[:hinta].to_s.to_d
  end

  def self.customer_price_with_info(customer_id, product_id)
    price = discount_price('asiakas', customer_id, product_id)
    price[:contract_price] = contract_price(price)
    price
  end

  def self.customer_subcategory_price(customer_subcategory_id, product_id)
    price = discount_price('asiakasryhma', customer_subcategory_id, product_id)
    price[:hinta].to_s.to_d
  end

  def self.customer_subcategory_price_with_info(customer_subcategory_id, product_id)
    price = discount_price('asiakasryhma', customer_subcategory_id, product_id)
    price[:contract_price] = contract_price(price)
    price
  end

  def self.pupesoft_function(function, params)
    Open3.popen2('php',
                 '-f',
                 'pupenext.php',
                 Current.company.yhtio,
                 Current.user.kuka,
                 function.to_s,
                 params.to_json,
                 chdir: LEGACY_API_DIR) do |_stdin, stdout, _stderr|
      JSON.parse(stdout.gets, symbolize_names: true)
    end
  rescue JSON::ParserError => e
    { error: "There was an error parsing the JSON response from Pupesoft. Message: #{e.message}" }
  end

  private

    def self.discount_price(target, target_id, product_id)
      Open3.popen2('php', '-f', 'alehinta.php',
                   Current.company.yhtio,
                   Current.user.kuka,
                   target,
                   target_id.to_s,
                   product_id.to_s,
                   chdir: LEGACY_API_DIR) do |_stdin, stdout, _stderr|
        JSON.parse(stdout.gets, symbolize_names: true)
      end
    rescue JSON::ParserError
      {
        ale_peruste: '',
        hinta: 0,
        hinta_peruste: 0,
      }
    end

    def self.contract_price(price)
      !(price[:hinta_peruste].to_i == 18 && price[:ale_peruste].in?(['', '13']))
    end
end
