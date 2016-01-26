module CommodityHelper
  def commodity_type(type)
    case type.to_s.capitalize.to_sym
    when :T
      return t('fixed_assets.commodities.model.straight_line_annual_rate_month')
    when :P
      return t('fixed_assets.commodities.model.straight_line_annual_rate_percentage')
    when :B
      return t('fixed_assets.commodities.model.declining_annual_rate')
    end
  end

  def commodity_status(status)
    case status.to_s.capitalize
    when 'A'
      return t('fixed_assets.commodities.model.activated')
    when 'P'
      return t('fixed_assets.commodities.model.deactivated')
    when ''
      return t('fixed_assets.commodities.model.not_activated')
    end
  end

  def commodity_options_for_type
    [
      ['Valitse',''],
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def commodity_options_for_status
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
  end
end
