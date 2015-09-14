class Location < BaseModel

  has_many :heads, foreign_key: :yhtio_toimipaikka

  self.table_name = :yhtion_toimipaikat
  self.primary_key = :tunnus

  def self.countries
    self.uniq.pluck(:maa)
  end
end
