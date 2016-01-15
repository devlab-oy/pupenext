class DynamicTreeNode < BaseModel
  include PupenextSingleTableInheritance

  self.table_name         = :puun_alkio
  self.primary_key        = :tunnus
  self.inheritance_column = :laji

  belongs_to :dynamic_tree, foreign_key: :puun_tunnus

  def self.default_child_instance
    child_class :tuote
  end

  def self.child_class_names
    { tuote: DynamicTreeNode::ProductNode }.stringify_keys
  end
end
