module CommodityHelper
  def commodity_type(type)
    case type.capitalize.to_sym
    when :T
      return t('fixed_assets.commodities.model.straight_line_annual_rate_month')
    when :P
      return t('fixed_assets.commodities.model.straight_line_annual_rate_percentage')
    when :B
      return t('fixed_assets.commodities.model.declining_annual_rate')
    end
  end
end
