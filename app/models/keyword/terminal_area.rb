class Keyword::TerminalArea < Keyword
  validates :selitetark, presence: true

  alias_attribute :code,  :selite
  alias_attribute :label, :selitetark

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TERMINAALIALUE'
  end
end
