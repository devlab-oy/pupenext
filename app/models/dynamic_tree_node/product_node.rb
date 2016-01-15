class DynamicTreeNode::ProductNode < DynamicTreeNode
  belongs_to :product, foreign_key: :liitos, primary_key: :tuoteno

  def self.sti_name
    'tuote'
  end
end
