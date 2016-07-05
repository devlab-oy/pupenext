class Campaign < BaseModel
  include Searchable

  belongs_to :company

  validates :name, length: { maximum: 60 }
  validates :description, length: { maximum: 255 }

  scope :active, -> { where(active: true) }
end
