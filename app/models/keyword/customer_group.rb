class Keyword::CustomerGroup < Keyword
  has_many :customers, foreign_key: :luokka, primary_key: :selite

  validates :selitetark, presence: true

  alias_attribute :code,  :selite
  alias_attribute :label, :selitetark

  def self.sti_name
    :ASIAKASLUOKKA
  end
end
