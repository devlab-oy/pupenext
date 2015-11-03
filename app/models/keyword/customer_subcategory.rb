class Keyword::CustomerSubcategory < Keyword
  has_many :customers, foreign_key: :ryhma, primary_key: :selite

  def to_s
    selitetark
  end

  def self.sti_name
    :ASIAKASRYHMA
  end
end
