class BankAccount < ActiveRecord::Base

  include BankHelper

  before_validation :check_number_format

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validate :check_iban

  validates :tilino, :oletus_kohde, :oletus_kustp,
            :oletus_projekti, presence: true
  validates :asiakas, :tilinylitys, :generointiavain, presence: true, allow_blank: true

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  private

    def check_number_format
      #iban = check_iban(iban)
      #if iban.empty? && !tilino.empty?
    end

    def check_iban
      iban.gsub!(/\s+/, "")
      errors.add(:iban, 'IBAN not valid') if iban.empty? && iban.nil?
      return true if company.maa != 'FI' # IBAN can only be checked for FI for now
      iban.upcase!
      required_length = check_sepa(company.maa)

      if check_sepa(company.maa) != iban.length
        errors.add(:iban, "in country #{company.maa} length should be #{check_sepa(company.maa)}")
      end
      true
    end

    def calculate(number)
      number =
    end

    def check_bic
      errors.add(:bic, 'BIC not valid') if bic.empty? && bic.nil?
      return true if company.maa != 'FI'

    end

end