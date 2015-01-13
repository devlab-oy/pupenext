class Permission < ActiveRecord::Base
  belongs_to :user

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
