class Permission < ActiveRecord::Base
  belongs_to :user

  scope :update_permissions, -> { where(paivitys: 1) }

  def self.read_access(resource, options = {})
    if options[:classic]
      where(nimi: resource)
    else
      where(nimi: "pupenext#{resource}")
    end
  end

  def self.update_access(resource, options = {})
    if options[:classic]
      where(nimi: resource, paivitys: 1)
    else
      where(nimi: "pupenext#{resource}", paivitys: 1)
    end
  end

  # Map old database schema table to User class
  self.table_name = :oikeu
  self.primary_key = :tunnus
end
