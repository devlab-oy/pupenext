class Carrier < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name  = "rahdinkuljettajat"
  self.primary_key = "tunnus"
end
