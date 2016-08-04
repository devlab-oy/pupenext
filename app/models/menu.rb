class Menu < BaseModel
  validates :kuka, absence: true
  validates :nimi, presence: true, uniqueness: { scope: [:yhtio, :sovellus, :alanimi, :kuka, :profiili] }
  validates :nimitys, presence: true
  validates :profiili, absence: true

  # käyttöoikeus on 'Menu' jos profiili ja kuka on tyhjää
  # käyttöoikeus on 'Permission' jos profiili on tyhjää ja kuka ei ole tyhjää
  # käyttöoikeus on 'UserProfile' jos profiili ei ole tyhjää, ja kuka = profiili
  default_scope { where(kuka: '', profiili: '') }

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
