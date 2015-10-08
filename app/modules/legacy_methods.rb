require('open3')

module LegacyMethods
  LEGACY_API_DIR = "#{Rails.application.secrets.pupesoft_install_dir}/rajapinnat"

  class << self
    def customer_price(customer_id, product_id)
      price = nil

      Open3.popen2('php',
                   '-f',
                   'alehinta.php',
                   Current.company.yhtio,
                   Current.user.kuka,
                   'asiakas',
                   customer_id.to_s,
                   product_id.to_s,
                   chdir: LEGACY_API_DIR) do |_i, o, _t|
        price = JSON.parse(o.gets, symbolize_names: true)
      end

      price[:price].to_d
    end
  end
end
