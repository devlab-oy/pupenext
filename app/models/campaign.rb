class Campaign < BaseModel
  include Searchable

  belongs_to :company

  scope :active, -> { where(active: true) }
end
