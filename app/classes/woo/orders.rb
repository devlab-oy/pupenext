class Woo::Orders < Woo::Base
  attr_accessor :edi_orders_path

  def initialize(company_id:, orders_path:)
    self.edi_orders_path = orders_path

    super
  end

  # Fetch new WooCommerce orders and set status to processing
  def fetch
    # Fetch orders from woocommerce
    response = woo_get('orders', status: 'any')
    return unless response

    response.each do |order|
      # update orders status to 'fetched'
      status = woo_put("orders/#{order['id']}", status: 'processing')

      next unless status

      write_to_file(order)
    end
  end

  # Set WooCommerce order status to complete
  def complete_order(order_number, tracking_code = nil)
    order = woo_get("orders/#{order_number}")
    return unless order

    status = woo_put("orders/#{order['id']}", status: 'completed')
    return unless status

    data = { note: tracking_code, customer_note: true }
    status = woo_post("orders/#{order_number}/notes", data)
    return unless status

    logger.info "Order #{order['id']} status set to completed"
  end

  def write_to_file(order)
    filepath = File.join(edi_orders_path, "order_#{order['id']}.txt")

    File.open(filepath, 'w') do |file|
      file.write(build_edi_order(order))
    end

    logger.info "Tallennettiin tilaus #{filepath}"
  end

  def build_edi_order(order)
    locals = { :@company => Current.company, :@order => order }

    ApplicationController.new.render_to_string 'data_import/edi_order', layout: false, locals: locals
  end
end
