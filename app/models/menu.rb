class Menu < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :kuka, absence: true
  validates :profiili, absence: true
  validates :nimi, presence: true, uniqueness: { scope: [:yhtio, :sovellus, :alanimi] }

  # menu on 'Permission', jossa profiili ja kuka kenttä on tyhjää
  default_scope { where(kuka: '', profiili: '') }

  self.table_name = :oikeu
  self.primary_key = :tunnus
end
