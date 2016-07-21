class Category::Product < Category
  has_many :links, foreign_key: :puun_tunnus, class_name: 'ProductLink'
  has_many :products, through: :links

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'tuote'
  end
end
