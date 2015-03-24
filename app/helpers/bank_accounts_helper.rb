module BankAccountsHelper
  def currency_options
    current_company.currencies.order(:jarjestys)
  end

  def hyvaksyja_options
    current_company.users.select(:kuka, :nimi).order(:nimi)
  end

  def kustannuspaikka_options
    current_company.cost_centers.order("koodi+0, koodi, nimi")
  end

  def kohde_options
    current_company.targets.order("koodi+0, koodi, nimi")
  end

  def projekti_options
    current_company.projects.order("koodi+0, koodi, nimi")
  end
end
