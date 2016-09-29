class User < BaseModel
  include Searchable

  has_many :downloads, class_name: 'Download::Download'
  has_many :files, through: :downloads, class_name: 'Download::File'
  has_many :permissions

  validates :kuka, presence: true, uniqueness: { scope: [:yhtio] }
  validates :kieli, inclusion: { in: Dictionary.locales }
  validates :tuuraaja, inclusion: { in: ->(_) { User.temp_acceptors.pluck(:kuka) } }, allow_blank: true

  enum taso: {
    acceptor_admin: 2,
    acceptor_basic: 1,
    acceptor_beginner: 9,
    acceptor_super: 3,
  }

  self.table_name = :kuka
  self.primary_key = :tunnus

  scope :temp_acceptors, -> { where("hyvaksyja != '' and extranet = ''") }

  def locale
    Dictionary.locales.include?(kieli) ? kieli : 'fi'
  end

  def can_read?(resource, options = {})
    permissions.read_access(resource, options).present?
  end

  def can_update?(resource, options = {})
    permissions.update_access(resource, options).present?
  end

  def classic_ui?
    kayttoliittyma == 'C' || (kayttoliittyma.blank? && company.classic_ui?)
  end

  def update_permissions
    # mark all current user permissions with a uid
    marked_for_delete = SecureRandom.uuid
    permissions.update_all muuttaja: marked_for_delete

    # fetch permissions this user should have
    user_permissions.each do |p|
      # check if user has this permission
      permission = permissions.find_or_initialize_by find_by_parameters(p)

      # update permission with valid info, don't raise exception, just fail if incorret
      permission.update update_with_parameters(p)
    end

    # remove permission user no longer has. update above changes muuttaja to current user
    permissions.where(muuttaja: marked_for_delete).delete_all
  end

  def profiles
    profiilit.to_s.split ','
  end

  private

    def user_permissions
      # fetch all user profiles and users locked permissions
      # we need to order profiles by paivitys, so we'll get update permissions later in the array
      params = company.user_profiles.where(profiili: profiles).order(:paivitys).map(&:attributes)

      # add locked parameters to the end of array, these override all profile attributes
      params << permissions.locked_permissions.map(&:attributes)

      params.flatten.uniq
    end

    def find_by_parameters(attributes)
      # these are the unique attributes, we should fetch the permission by
      {
        alanimi:  attributes['alanimi'],
        nimi:     attributes['nimi'],
        nimitys:  attributes['nimitys'],
        sovellus: attributes['sovellus'],
      }
    end

    def update_with_parameters(attributes)
      # these are the attributes we need to update for the user permission
      {
        hidden:        attributes['hidden'],
        jarjestys2:    attributes['jarjestys2'],
        jarjestys:     attributes['jarjestys'],
        kuka:          kuka,
        lukittu:       attributes['lukittu'],
        muuttaja:      Current.user || kuka,
        nimi:          attributes['nimi'],
        nimitys:       attributes['nimitys'],
        paivitys:      attributes['paivitys'],
        sovellus:      attributes['sovellus'],
        usermanualurl: attributes['usermanualurl'],
      }
    end
end
