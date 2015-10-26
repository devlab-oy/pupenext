class Keyword::ProductKeywordType < Keyword
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TUOTEULK'
  end

  def product_key
    selite
  end
end
