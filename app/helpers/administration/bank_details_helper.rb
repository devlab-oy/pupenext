module Administration::BankDetailsHelper
  def nimitys_teksti(nimitys)
    nimitys.present? ? nimitys : "*#{t('administration.bank_details_helper.empty')}*"
  end

  def viite_options
    [
      [ t('administration.bank_details_helper.finnish'), 'finnish'   ],
      [ t('administration.bank_details_helper.swedish'), 'swedish' ],
    ]
  end
end
