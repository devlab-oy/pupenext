class Keyword::CustomerPriceListAttribute < Keyword
  def self.sti_name
    'ASIAKHIN_ATTR'
  end

  def self.message
    find_by(selite: 'viesti').selitetark
  end
end
