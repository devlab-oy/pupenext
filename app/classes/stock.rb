class Stock
  def initialize(product)
    @product = product
  end

  def stock
    return 0 if @product.no_inventory_management?

    @product.shelf_locations.sum(:saldo)
  end
end
