class Permission < BaseModel
  belongs_to :user

  scope :update_permissions, -> { where(paivitys: 1) }

  alias_attribute :resource, :nimi
  alias_attribute :alias_set, :alanimi

  def self.read_access(resource, options = {})
    nimi    = options[:classic]   ? resource : "pupenext#{resource}"
    alanimi = options[:alias_set] ? options[:alias_set] : ''

    where nimi: nimi, alanimi: alanimi
  end

  def self.update_access(resource, options = {})
    update_permissions.read_access resource, options
  end

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
