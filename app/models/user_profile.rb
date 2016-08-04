class UserProfile < BaseModel
  validates :jarjestys, uniqueness: { scope: [:yhtio, :sovellus, :jarjestys2] }
  validates :kuka, presence: true
  validates :nimi, presence: true, uniqueness: { scope: [:yhtio, :profiili, :sovellus, :alanimi] }
  validates :nimitys, presence: true
  validates :profiili, presence: true

  # käyttöoikeus on 'Menu' jos profiili ja kuka on tyhjää
  # käyttöoikeus on 'Permission' jos profiili on tyhjää ja kuka ei ole tyhjää
  # käyttöoikeus on 'UserProfile' jos profiili ei ole tyhjää, ja kuka = profiili
  default_scope { where.not(profiili: '').where('oikeu.kuka = oikeu.profiili') }

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
