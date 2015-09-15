class BankDetail < BaseModel
  validates :nimitys, presence: true

  enum viite: {
    finnish: '',
    swedish: 'SE'
  }

  self.table_name = :pankkiyhteystiedot
  self.primary_key = :tunnus

  def bank_account_details
    accounts = []

    accounts << {
      name: pankkinimi1,
      iban: pankkiiban1,
      bic: pankkiswift1
    }

    accounts << {
      name: pankkinimi2,
      iban: pankkiiban2,
      bic: pankkiswift2
    }

    accounts << {
      name: pankkinimi3,
      iban: pankkiiban3,
      bic: pankkiswift3
    }

    accounts.reject { |a| a[:name].blank? }
  end
end
