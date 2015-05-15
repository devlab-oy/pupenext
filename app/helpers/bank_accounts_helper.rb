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
end
