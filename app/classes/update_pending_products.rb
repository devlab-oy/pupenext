class UpdatePendingProducts
  Response = Struct.new :update_count, :failed_count, :errors

  def initialize(company_id:, product_ids:)
    Current.company = Company.find company_id

    @errors = []
    @failed_count = 0
    @product_ids = product_ids
    @update_count = 0
  end

  def update
    products.each do |product|
      release_pending_update product
    end

    Response.new @update_count, @failed_count, @errors.flatten
  end

  private

    def fetch_params(product)
      product.pending_updates.inject({}) do |result, pu|
        result.merge({ pu.key => pu.value })
      end
    end

    def release_pending_update(product)
      params = fetch_params product

      if product.update params
        product.pending_updates.delete_all
        @update_count += params.length
      else
        @failed_count += params.length
        @errors << product.errors.full_messages
      end
    end

    def products
      @products ||= Product.find(@product_ids)
    end
end
