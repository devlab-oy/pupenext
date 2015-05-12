module Administration::BankDetailsHelper
  def nimitys_teksti(nimitys)
    nimitys.present? ? nimitys : "*#{t("tyhjä")}*"
  end
end
