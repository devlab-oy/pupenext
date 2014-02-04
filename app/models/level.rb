class Level < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to CashBox class
  self.table_name  = "taso"
  self.primary_key = "tunnus"

  def taso_nimi
    "#{taso} #{nimi}"
  end

end
