class Permission < BaseModel
  belongs_to :user

  scope :update_permissions, -> { where(paivitys: 1) }

  def self.read_access(resource, options = {})
    nimi = options[:classic] ? resource : "pupenext#{resource}"

    where nimi: nimi
  end

  def self.update_access(resource, options = {})
    update_permissions.read_access resource, options
  end

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
