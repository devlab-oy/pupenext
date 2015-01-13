class Parameter < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to Company class
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus
end
