class Preorder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'Preorder::Row'

  validates :tila, inclusion: { in: ['E'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "E"
  end
end
