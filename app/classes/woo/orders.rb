class Woo::Orders < Woo::Base
  attr_accessor :edi_orders_path, :customer_id, :order_status, :order_status_after

  # Fetch new WooCommerce orders and set status to processing
  def fetch(orders_path:, customer_id: nil, order_status: 'processing', order_status_after: 'testi')
    self.edi_orders_path = orders_path
    self.customer_id = customer_id
    self.order_status = order_status

    # Fetch only order that are 'processing'
    response = woo_get('orders', status: order_status)

    logger.info "json: \n\n #{response.to_s}\n\n'"

    return unless response

    response.each do |order|
      # update orders status to 'on-hold'
      status = woo_put("orders/#{order['id']}", status: order_status_after)
      logger.info "Order #{order['id']} status set to #{order_status_after}"
      next unless status

      #changing the postnord_service_point_id to carrier_agent_id form metadata
      carrier_agent_id = order['meta_data'].select {|meta| meta["key"] == '_woo_carrier_agent_id'}
      unless carrier_agent_id.empty?
        order["shipping_lines"][0]["postnord_service_point_id"] = carrier_agent_id[0]["value"]
      end

      # Check if order already is in Pupesoft
      @pupe_draft = SalesOrder::Draft.find_by(laatija: 'WooCommerce', asiakkaan_tilausnumero: order['id'])
      @pupe_order = SalesOrder::Order.find_by(laatija: 'WooCommerce', asiakkaan_tilausnumero: order['id'])

      if @pupe_draft.nil? && @pupe_order.nil?
        logger.info "Order #{order['id']} fetched and put in Pupesoft processing queue"
        write_to_file(order)
      else
        logger.info "Order #{order['id']} NOT fetched beacause it already exists in Pupesoft"
      end
    end
  end

  # Set WooCommerce order status to complete
  def complete_order(order_number, tracking_code = nil)
    # only update if order is 'on-hold'
    order = woo_get("orders/#{order_number}")
    logger.info "#{order}"
    return unless order
    return unless order['status'] == 'on-hold' || order['status'] == 'warehouse-process'

    status = woo_put("orders/#{order['id']}", status: 'completed')
    return unless status

    logger.info "Order #{order['id']} status set to completed"
    return unless tracking_code.present?
  
    data = { meta_data: [
      {
       	key: "_tracking_code",
        value: tracking_code
      }
    ],
    }

    meta_reply =  woo_put("orders/#{order['id']}", data)
    return unless status
    logger.info "Meta data #{meta_reply}"
    logger.info "Order #{order['id']} tracking code set to #{tracking_code}"
  end

  def write_to_file(order)
    filepath = File.join(edi_orders_path, "woo-order-#{order['id']}.txt")

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
