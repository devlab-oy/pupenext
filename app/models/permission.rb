class Permission < BaseModel
  belongs_to :user

  validates :jarjestys, uniqueness: { scope: [:yhtio, :user, :kuka, :sovellus, :jarjestys2] }
  validates :nimi, presence: true, uniqueness: { scope: [:yhtio, :user, :kuka, :sovellus, :alanimi] }
  validates :nimitys, presence: true
  validates :profiili, absence: true
  validates :sovellus, presence: true
  validates :user, presence: true

  scope :update_permissions, -> { where(paivitys: 1) }
  scope :locked_permissions, -> { where(lukittu: 1) }

  alias_attribute :resource, :nimi
  alias_attribute :alias_set, :alanimi

  # käyttöoikeus on 'Menu' jos profiili ja kuka on tyhjää
  # käyttöoikeus on 'Permission' jos profiili on tyhjää ja kuka ei ole tyhjää
  # käyttöoikeus on 'UserProfile' jos profiili ei ole tyhjää, ja kuka = profiili
  default_scope { where(profiili: '').where.not(kuka: '') }

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
