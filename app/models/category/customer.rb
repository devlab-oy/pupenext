class Category::Customer < Category
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'asiakas'
  end
end
