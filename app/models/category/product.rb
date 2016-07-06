class Category::Product < Category
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'tuote'
  end

  def as_json(options)
    options = { only: [:nimi, :koodi, :tunnus] }.merge(options)
    super options
  end
end
