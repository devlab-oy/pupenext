class Keyword::DeliveryMethodTranslation < Keyword
  belongs_to :delivery_method, foreign_key: :selite

  validates :selitetark, presence: true
  validates :kieli, inclusion: { in: Dictionary.locales }
  validates :kieli, uniqueness: { scope: [:yhtio, :selite] }

  # Rails requires sti_name method to return type column (laji) value
  def self.sti_name
    'TOIMTAPAKV'
  end
end
