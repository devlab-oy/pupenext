class Company < ActiveRecord::Base

  has_many :users, foreign_key: :yhtio, primary_key: :yhtio
  has_one :parameter, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to Company class
  self.table_name  = "yhtio"
  self.primary_key = "tunnus"

end
