class Language < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :country

  self.table_name  = "sanakirja"
  self.primary_key = "tunnus"
end
