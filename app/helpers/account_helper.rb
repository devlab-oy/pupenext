module AccountHelper
  ROOT = 'administration.accounts'

  def account_name(number)
    a = Account.find_by_tilino(number)
    a.present? ? a.nimi : ""
  end

  def toimijaliitos_options
    Account.toimijaliitos.map do |key,_|
      [ t("#{ROOT}.toimijaliitos_options.#{key}"), key ]
    end
  end

  def tiliointi_tarkistus_options
    Account.tiliointi_tarkistus.map do |key,_|
      [ t("#{ROOT}.tiliointi_tarkistus_options.#{key}"), key ]
    end
  end

  def manuaali_esto_options
    Account.manuaali_estos.map do |key,_|
      [ t("#{ROOT}.manuaali_esto_options.#{key}"), key ]
    end
  end
end
