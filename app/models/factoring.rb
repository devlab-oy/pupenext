class Factoring < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :factoring
  self.primary_key = :tunnus
  self.record_timestamps = false
end
