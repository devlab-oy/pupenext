class Keyword::ProductInformationType < Keyword
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'LISATIETO'
  end
end
