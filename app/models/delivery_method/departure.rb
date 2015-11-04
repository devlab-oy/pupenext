class DeliveryMethod::Departure < BaseModel
  include SplittableDates

  belongs_to :delivery_method, foreign_key: :liitostunnus
  belongs_to :warehouse, foreign_key: :varasto
  has_many :terminal_area, primary_key: :terminaalialue, foreign_key: :selite, class_name: 'Keyword::TerminalArea'

  validates :kerailyn_aloitusaika, :lahdon_kellonaika, :viimeinen_tilausaika,
            format: { with: /\d{2}:\d{2}:\d{2}/i }
  validates :lahdon_viikonpvm, :varasto, numericality: { only_integer: true }
  validates :terminaalialue, length: { within: 1..150 }, allow_blank: true
  validates :asiakasluokka, length: { within: 1..50 }, allow_blank: true
  validates :ohjausmerkki, length: { within: 1..70 }, allow_blank: true

  splittable_dates :alkupvm

  def kerailyn_aloitusaika
    TimeOfDay.new(time: read_attribute(:kerailyn_aloitusaika))
  end

  def lahdon_kellonaika
    TimeOfDay.new(time: read_attribute(:lahdon_kellonaika))
  end

  def viimeinen_tilausaika
    TimeOfDay.new(time: read_attribute(:viimeinen_tilausaika))
  end

  self.table_name = :toimitustavan_lahdot
  self.primary_key = :tunnus

  enum aktiivi: {
    in_use: '',
    not_in_use: 'E'
  }
end
