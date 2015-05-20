class Location < BaseModel
  self.table_name = :yhtion_toimipaikat
  self.primary_key = :tunnus

  def self.countries
    self.uniq.pluck(:maa)
  end
end
