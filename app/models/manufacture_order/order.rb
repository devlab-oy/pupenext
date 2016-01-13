class ManufactureOrder::Order < Head
  has_many :rows, foreign_key: :otunnus, class_name: 'ManufactureOrder::Row'
  has_many :composite_rows, foreign_key: :otunnus, class_name: 'ManufactureOrder::CompositeRow'
  has_many :recursive_composite_rows, foreign_key: :otunnus, class_name: 'ManufactureOrder::RecursiveCompositeRow'

  validates :tila, inclusion: { in: ['V'] }

  scope :not_manufactured, -> { where(alatila: ['', :K, :J, :A, :C]) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "V"
  end
end
