class Factoring < BaseModel
  has_many :terms_of_payments, foreign_key: :factoring, primary_key: :factoringyhtio

  self.table_name = :factoring
  self.primary_key = :tunnus
  self.record_timestamps = false

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

    accounts.reject { |a| a[:name].blank? }
  end
end
