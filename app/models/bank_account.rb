class BankAccount < ActiveRecord::Base

  #include BankHelper

  before_validation :check_number_format

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  #validate :check_iban

  validates :tilino, :oletus_kohde, :oletus_kustp,
            :oletus_projekti, presence: true
  validates :asiakas, :tilinylitys, :generointiavain, presence: true, allow_blank: true

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  private

    def check_number_format
      #if iban.empty? && !tilino.empty?
    end

    def check_iban
      iban.gsub!(/\s+/, "")
      errors.add(:iban, 'IBAN not valid') if iban.empty? && iban.nil?
      return true if company.maa != 'FI'
      iban.upcase!
      errors.add(:iban, "#{iban} is not valid") if check_sepa(company.maa) != iban.length
    end

    def check_bic
      errors.add(:bic, 'BIC not valid') if bic.empty? && bic.nil?
      return true if company.maa != 'FI'

    end

end