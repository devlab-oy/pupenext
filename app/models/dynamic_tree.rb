class DynamicTree < BaseModel
  self.table_name  = :dynaaminen_puu
  self.primary_key = :tunnus

  has_many :supplier_product_informations, foreign_key: :p_tree_id
  has_many :product_nodes, class_name: 'DynamicTreeNode::ProductNode', foreign_key: :puun_tunnus
  has_many :products, through: :product_nodes
end
