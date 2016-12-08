class Woo::Orders < Woo::Base
  attr_accessor :edi_orders_path, :customer_id

  # Fetch new WooCommerce orders and set status to processing
  def fetch(orders_path:, customer_id: nil)
    self.edi_orders_path = orders_path
    self.customer_id = customer_id

    # Fetch only order that are 'processing'
    response = woo_get('orders', status: 'processing')
    return unless response

    response.each do |order|
      # update orders status to 'on-hold'
      status = woo_put("orders/#{order['id']}", status: 'on-hold')

      next unless status

      write_to_file(order)
    end
  end

  # Set WooCommerce order status to complete
  def complete_order(order_number, tracking_code = nil)
    # only update if order is 'on-hold'
    order = woo_get("orders/#{order_number}")
    return unless order && order['status'] == 'on-hold'

    status = woo_put("orders/#{order['id']}", status: 'completed')
    return unless status

    logger.info "Order #{order['id']} status set to completed"
    return unless tracking_code.present?

    data = { note: tracking_code, customer_note: true }
    status = woo_post("orders/#{order_number}/notes", data)
    return unless status

    logger.info "Order #{order['id']} tracking code set to #{tracking_code}"
  end

  def write_to_file(order)
    filepath = File.join(edi_orders_path, "order_#{order['id']}.txt")

    File.open(filepath, 'w') do |file|
      file.write(build_edi_order(order))
    end

    logger.info "Tallennettiin tilaus #{filepath}"
  end

  def build_edi_order(order)
    locals = { :@company => Current.company, :@order => order, :@customer_id => customer_id }

    ApplicationController.new.render_to_string 'data_import/edi_order', layout: false, locals: locals
  end
end
