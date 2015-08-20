class Parameter < BaseModel
  self.table_name = :yhtion_parametrit
  self.primary_key = :tunnus

  def use_kerayserat?
    kerayserat == 'K'
  end
end
