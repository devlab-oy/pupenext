module BankAccountsHelper
  def tili_kaytossa_options
    [
      [ t('administration.bank_accounts.kaytossa_options.active'),   :active   ],
      [ t('administration.bank_accounts.kaytossa_options.inactive'), :inactive ],
    ]
  end

  def bank_account_factoring_options
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
