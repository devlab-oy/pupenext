class PackageCode < BaseModel
  validates :koodi, presence: true

  self.table_name  = :pakkauskoodit
  self.primary_key = :tunnus
end
