class Category < BaseModel
  include PupenextSingleTableInheritance

  acts_as_nested_set depth_column: :syvyys, primary_column: :tunnus, scope: [:yhtio, :laji]

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

  def self.tree
    roots.map(&:tree)
  end

  def as_json(options = {})
    options = { only: [:nimi, :koodi, :tunnus] }.merge(options)
    super options
  end

  def tree
    nodes_children = children.map(&:tree)
    as_json.merge('children' => nodes_children)
  end
end

require_dependency 'category/customer'
require_dependency 'category/product'
