class BankAccount < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :iban, :tilinylitys, :pankki, :oletus_kohde, :oletus_kustp,
            :oletus_projekti, presence: true
  validates :asiakas, :generointiavain, presence: true, allow_blank: true

  self.table_name = 'yriti'
  self.primary_key = 'tunnus'

  self.record_timestamps = false

  private

end