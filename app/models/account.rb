class CashBox < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :ulkoinen_taso, presence: true

  # Map old database schema table to CashBox class
  self.table_name  = "tili"
  self.primary_key = "tunnus"

end
