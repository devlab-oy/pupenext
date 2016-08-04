class UserProfile < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :profiili, presence: true
  validates :nimi, presence: true, uniqueness: { scope: [:yhtio, :profiili, :sovellus, :alanimi] }

  # käyttäjäprofiili on 'Permission', jossa profiili kenttä ei ole tyhjää
  default_scope { where.not(profiili: '').where('oikeu.kuka = oikeu.profiili') }

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
