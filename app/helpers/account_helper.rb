module AccountHelper
  ROOT = 'administration.accounts'

  def account_name(number)
    a = Account.find_by_tilino(number)
    a.present? ? a.nimi : ""
  end

  def toimijaliitos_options
    Account.toimijaliitos.map do |key, value|
      [ t("#{ROOT}.toimijaliitos_options.#{key}"), value ]
    end
  end

  def tiliointi_tarkistus_options
    Account.tiliointi_tarkistus.map do |key, value|
      [ t("#{ROOT}.tiliointi_tarkistus_options.#{key}"), value ]
    end
  end

  def manuaali_esto_options
    Account.manuaali_estos.map do |key, value|
      [ t("#{ROOT}.manuaali_esto_options.#{key}"), value ]
    end
  end
end
