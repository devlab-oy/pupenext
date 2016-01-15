class ProjectOrder::Row < Row
  belongs_to :order, foreign_key: :otunnus, class_name: 'ProjectOrder::Order'

  validates :tyyppi, inclusion: { in: ['L'] }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "R"
  end
end
