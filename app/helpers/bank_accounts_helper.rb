module BankAccountsHelper
  def currency_options
    Currency.order(:jarjestys).pluck(:nimi)
  end

  def hyvaksyja_options
    User.select(:kuka, :nimi).order(:nimi)
  end

  def kustannuspaikka_options
    Qualifier::CostCenter.order('koodi+0, koodi, nimi')
  end

  def kohde_options
    Qualifier::Target.order('koodi+0, koodi, nimi')
  end

  def projekti_options
    Qualifier::Project.order('koodi+0, koodi, nimi')
  end

  def tili_kaytossa_options
    [
      [ t('administration.bank_accounts.kaytossa_options.active'),   :active   ],
      [ t('administration.bank_accounts.kaytossa_options.inactive'), :inactive ],
    ]
  end

  def factoring_options
    [
      [ t('administration.bank_accounts.factoring_options.factoring_disabled'), :factoring_disabled ],
      [ t('administration.bank_accounts.factoring_options.factoring_enabled'),  :factoring_enabled  ],
    ]
  end

  def tilinylitys_options
    [
      [ t('administration.bank_accounts.tilinylitys_options.limit_override_denied'),  :limit_override_denied  ],
      [ t('administration.bank_accounts.tilinylitys_options.limit_override_allowed'), :limit_override_allowed ],
    ]
  end
end
