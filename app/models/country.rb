class Country < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :language

  self.table_name  = "maat"
  self.primary_key = "tunnus"
end
