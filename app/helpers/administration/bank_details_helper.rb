module Administration::BankDetailsHelper
  def nimitys_teksti(nimitys)
    nimitys.present? ? nimitys : "*#{t('.empty')}*"
  end

  def viite_options
    [
      [ t('.finnish'), ''   ],
      [ t('.swedish'), 'SE' ],
    ]
  end
end
