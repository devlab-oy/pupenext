module PendingProductUpdatesHelper
  def pending_ei_saldoa_options
    [
      [t('pending_product_updates.pending_ei_saldoa_options.inventory_management'),    '@'],
      [t('pending_product_updates.pending_ei_saldoa_options.no_inventory_management'), '@o']
    ]
  end

  def pending_status_options
    [
      [t('pending_product_updates.pending_status_options.active'),  ''],
      [t('pending_product_updates.pending_status_options.deleted'), '@P']
    ]
  end

  def pending_columns_options
    [
      [t('pending_product_updates.pending_columns_options.sales_price'),       'myyntihinta'],
      [t('pending_product_updates.pending_columns_options.shop_price'),        'myymalahinta'],
      [t('pending_product_updates.pending_columns_options.short_description'), 'lyhytkuvaus']
    ]
  end

  def pending_price_options
    [
      [t('pending_product_updates.pending_price_options.sales_price'), 'myyntihinta'],
      [t('pending_product_updates.pending_price_options.shop_price'),  'myymalahinta'],
    ]
  end
end
