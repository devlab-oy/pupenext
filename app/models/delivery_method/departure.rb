class DeliveryMethod::Departure < BaseModel
  belongs_to :delivery_method, foreign_key: :liitostunnus
  has_many :terminal_area, primary_key: :terminaalialue, foreign_key: :selite, class_name: 'Keyword::TerminalArea'

  validates :kerailyn_aloitusaika, :lahdon_kellonaika, :viimeinen_tilausaika,
            format: { with: /\d{2}:\d{2}:\d{2}/i }
  validates :lahdon_viikonpvm, numericality: { only_integer: true }
  validates :terminaalialue, length: { within: 1..150 }, allow_blank: true
  validates :asiakasluokka, length: { within: 1..50 }, allow_blank: true

  def kerailyn_aloitusaika
    TimeOfDay.new(time: read_attribute(:kerailyn_aloitusaika))
  end

  self.table_name = :toimitustavan_lahdot
  self.primary_key = :tunnus
end
