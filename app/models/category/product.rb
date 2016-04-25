class Category::Product < Category
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'tuote'
  end
end
