class ProjectOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'ProjectOrder::Row'

  validates :tila, inclusion: { in: ['R'] }

  scope :active, -> { where(alatila: %W(#{} A)) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "R"
  end
end
