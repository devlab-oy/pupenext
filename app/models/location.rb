class Location < BaseModel
  has_and_belongs_to_many :delivery_methods, join_table: 'toimitustavat_toimipaikat', association_foreign_key: 'toimitustapa_tunnus', foreign_key: 'toimipaikka_tunnus'

  self.table_name = :yhtion_toimipaikat
  self.primary_key = :tunnus

  def self.countries
    self.uniq.pluck(:maa)
  end
end
