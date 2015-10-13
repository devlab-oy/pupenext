require('open3')

module LegacyMethods
  LEGACY_API_DIR = "#{Rails.application.secrets.pupesoft_install_dir}/rajapinnat"

  def self.customer_price(customer_id, product_id)
    discount_price('asiakas', customer_id, product_id)
  end

  def self.customer_subcategory_price(customer_subcategory_id, product_id)
    discount_price('asiakasryhma', customer_subcategory_id, product_id)
  end

  private

    def self.discount_price(target, target_id, product_id)
      Open3.popen2('php',
                   '-f',
                   'alehinta.php',
                   Current.company.yhtio,
                   Current.user.kuka,
                   target,
                   target_id.to_s,
                   product_id.to_s,
                   chdir: LEGACY_API_DIR) do |_i, o, _t|
        price = JSON.parse(o.gets, symbolize_names: true)
        price[:hinta].to_s.to_d
      end
    end
end
