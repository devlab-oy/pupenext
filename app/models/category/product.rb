class Category::Product < Category
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'tuote'
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
