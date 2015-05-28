class Storage < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to Qualifier class
  self.table_name  = :varastopaikat
  self.primary_key = :tunnus
end
