class Keyword::CustomerCategory < Keyword
  has_many :customers, foreign_key: :osasto, primary_key: :selite

  validates :selitetark, presence: true

  alias_attribute :code,  :selite
  alias_attribute :label, :selitetark

  def to_s
    selitetark
  end

  def self.sti_name
    :ASIAKASOSASTO
  end
end
