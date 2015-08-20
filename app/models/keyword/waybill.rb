class Keyword::Waybill < Keyword
  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'RAHTIKIRJA'
  end
end
