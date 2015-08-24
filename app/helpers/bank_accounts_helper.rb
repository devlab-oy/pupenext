module BankAccountsHelper
  def currency_options
    Currency.order(:jarjestys).pluck(:nimi)
  end

  def hyvaksyja_options
    User.select(:kuka, :nimi).order(:nimi)
  end

  def kustannuspaikka_options
    Qualifier::CostCenter.order("koodi+0, koodi, nimi")
  end

  def kohde_options
    Qualifier::Target.order("koodi+0, koodi, nimi")
  end

  def projekti_options
    Qualifier::Project.order("koodi+0, koodi, nimi")
  end

  def kaytossa_options
    [
      [t("Käytössä"), ""],
      [t("Poistettu / Ei käytössä"), "E"]
    ]
  end

  def factoring_options
    [
      [t("Ei"), ""],
      [t("Kyllä"), "o"]
    ]
  end

  def tilinylitys_options
    [
      [t("Tilinylitys ei sallittu"), ""],
      [t("Tilinylitys sallittu"), "o"]
    ]
  end
end
