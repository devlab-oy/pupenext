class Keyword::PackageTranslation < Keyword
  belongs_to :package, foreign_key: :selite, primary_key: :tunnus

  validates :selitetark, presence: true
  validates :kieli, inclusion: { in: %w{ee en no se de dk ru} }
  validates :kieli, uniqueness: { scope: [:yhtio, :selite] }

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'PAKKAUSKV'
  end
end
