class BankAccount < ActiveRecord::Base

  include BankHelper

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :iban, presence: true, uniqueness: { scope: :company }
  validates :oletus_rahatili, presence: true
  validates :oletus_kulutili, presence: true
  validates :oletus_selvittelytili, presence: true

  validate :check_iban
  validate :check_bic

  before_validation :fix_numbers

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  default_scope { where kaytossa: '' }
  scope :unused, -> { where(kaytossa: 'E') }

  private

    def fix_numbers
      if iban.present? && !valid_iban?(iban)
        iban.upcase
        iban.gsub!(/[^A-Z0-9]/, '')
        # Try to create iban in case user has entered old account number
        self.iban = create_iban(iban)
      end

      # NOTE Remove this after column no longer present in the database
      self.tilino = iban
    end

    def check_iban
      errors.add(:iban, "invalid iban") unless valid_iban?(iban)
    end

    def check_bic
      errors.add(:bic, "invalid bic") unless valid_bic?(bic)
    end

end
