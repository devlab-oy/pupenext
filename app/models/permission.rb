class Permission < BaseModel
  belongs_to :user
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  scope :update_permissions, -> { where(paivitys: 1) }

  def self.read_access(resource)
    where(nimi: "pupenext#{resource}")
  end

  def self.update_access(resource)
    where(nimi: "pupenext#{resource}", paivitys: 1)
  end

  # Map old database schema table to User class
  self.table_name = :oikeu
  self.primary_key = :tunnus
end
