class Keyword::CustomerCategory < Keyword
  has_many :customers, foreign_key: :osasto, primary_key: :selite

  def to_s
    selitetark
  end

  def self.sti_name
    :ASIAKASOSASTO
  end
end
