class Package < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_many :keywords, foreign_key: :perhe, primary_key: :tunnus, class_name: 'PackageKeyword'
  has_many :package_codes, foreign_key: :pakkaus, primary_key: :tunnus

  validates :pakkaus, presence: true
  validates :pakkauskuvaus, presence: true

  self.table_name  = :pakkaus
  self.primary_key = :tunnus

  def on_off_options
    [
      ["Ei", "0"],
      ["Kyllä", "K"]
    ]
  end
end
