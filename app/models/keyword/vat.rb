class Keyword::Vat < Keyword
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'ALV'
  end
end
