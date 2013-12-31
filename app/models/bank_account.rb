class BankAccount < ActiveRecord::Base

  include BankHelper

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  before_validation :check_presence
  validates :tilino, :iban, presence: true, uniqueness: { scope: :company }
  validates :oletus_kohde, :oletus_kustp,
            :oletus_projekti, presence: true
  validates :asiakas, :tilinylitys, :generointiavain, presence: true, allow_blank: true
  validate :check_iban, :check_account_number, :check_bic

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  private

    def check_presence
      if iban.empty? && !tilino.empty?
        self.iban = create_iban(self.tilino)
      end
    end

    def check_account_number
      self.tilino = validate_account_number(tilino)
    end

    def check_iban
      self.iban = validate_iban(self.iban)
    end

    def check_bic
      return true if self.company.maa != "FI"
      check = validate_bic(self.bic)
      errors.add(:bic, "not valid") if check != 0
    end

end
