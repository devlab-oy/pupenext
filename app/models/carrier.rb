class Carrier < BaseModel
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, :koodi, presence: true
  validates :pakkauksen_sarman_minimimitta, numericality: true

  enum neutraali: {
    neutral: '',
    not_neutral: 'o'
  }

  self.table_name = :rahdinkuljettajat
  self.primary_key = :tunnus
end
