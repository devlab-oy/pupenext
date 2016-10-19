class Woo::Orders < Woo::Base
  def fetch
    #orders = @woocommerce.get("orders").parsed_response
    #woocommerce_orders = @woocommerce.get("orders", {status: 'any'}).parsed_response

    # tee edi tilauksia
    order = "kissa"
  end

  def build_edi_order(orders)
    ApplicationController.new.render_to_string 'data_import/edi_order',
      layout: false, locals: {:@order => first}
  end
end
