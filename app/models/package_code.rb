class PackageCode < BaseModel
  belongs_to :package, foreign_key: :pakkaus

  validates :koodi, presence: true

  self.table_name  = :pakkauskoodit
  self.primary_key = :tunnus
end
