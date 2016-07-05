class Category < BaseModel
  include PupenextSingleTableInheritance

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  acts_as_nested_set depth_column: :syvyys, primary_column: :tunnus

  self.table_name         = :dynaaminen_puu
  self.primary_key        = :tunnus
  self.inheritance_column = :laji

  def self.default_child_instance
    child_class :tuote
  end

  def self.child_class_names
    {
      asiakas: Category::Customer,
      tuote:   Category::Product,
    }.stringify_keys
  end
end

require_dependency 'category/product'
