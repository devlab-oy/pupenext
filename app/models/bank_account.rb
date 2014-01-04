class BankAccount < ActiveRecord::Base

  include BankHelper

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :tilino, presence: true, uniqueness: { scope: :company }
  validates :iban, presence: true, uniqueness: { scope: :company }
  validates :oletus_rahatili, presence: true
  validates :oletus_kulutili, presence: true
  validates :oletus_selvittelytili, presence: true

  validate :check_iban
  validate :check_account_number
  validate :check_bic

  before_validation :fix_account_numbers

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  private

    def fix_account_numbers
      if iban.present?
        iban.upcase!
        iban.gsub!(/[^A-Z0-9]/, '')
      end

      if tilino.present?
        tilino.gsub!(/\D/, '')
        self.tilino = pad_account_number(tilino)

        # If we have account number present but no IBAN, create IBAN
        self.iban = create_iban(tilino) unless iban.present?
      end
    end

    def check_account_number
      errors.add(:tilino, "invalid account number") unless valid_account_number?(tilino)
    end

    def check_iban
      errors.add(:iban, "invalid iban") unless valid_iban?(iban)
    end

    def check_bic
      errors.add(:bic, "invalid bic") unless valid_bic?(bic)
    end

end
