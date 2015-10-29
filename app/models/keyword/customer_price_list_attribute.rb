class Keyword::CustomerPriceListAttribute < Keyword
  validates :selitetark, presence: true

  def self.sti_name
    'ASIAKHIN_ATTR'
  end

  def self.message
    find_by(selite: 'viesti').try(:selitetark)
  end
end
