class PackageCode < BaseModel
  belongs_to :package, foreign_key: :pakkaus
  belongs_to :carrier, primary_key: :koodi, foreign_key: :rahdinkuljettaja

  validates :koodi, presence: true

  self.table_name  = :pakkauskoodit
  self.primary_key = :tunnus
end
