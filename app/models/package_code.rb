class PackageCode < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :koodi, presence: true

  self.table_name  = :pakkauskoodit
  self.primary_key = :tunnus
end
