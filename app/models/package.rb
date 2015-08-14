class Package < BaseModel
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_many :keywords, foreign_key: :perhe, primary_key: :tunnus, class_name: 'PackageKeyword'
  has_many :package_codes, foreign_key: :pakkaus, primary_key: :tunnus

  validates :pakkaus, presence: true
  validates :pakkauskuvaus, presence: true
  validates :kayttoprosentti, numericality: { greater_than: 0 }
  validates :leveys, :korkeus, :syvyys, :paino,
            numericality: { greater_than: 0 }, if: :dimensions_are_mandatory?

  enum rahtivapaa_veloitus: {
    add_rack_charge: '',
    no_rack_charge: 'E'
  }

  enum erikoispakkaus: {
    not_special: '',
    special: 'K'
  }

  enum yksin_eraan: {
    combined_parcel: '',
    separate_parcel: 'K'
  }

  self.table_name  = :pakkaus
  self.primary_key = :tunnus

  def dimensions_are_mandatory?
    company.parameter.varastopaikkojen_maarittely == "M"
  end
end
