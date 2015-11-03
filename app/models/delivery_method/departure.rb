class DeliveryMethod::Departure < BaseModel
  belongs_to :delivery_method, foreign_key: :liitostunnus

  validates :kerailyn_aloitusaika, format: { with: /\d{2}:\d{2}:\d{2}/i }

  def kerailyn_aloitusaika
    TimeOfDay.new(time: read_attribute(:kerailyn_aloitusaika))
  end

  self.table_name = :toimitustavan_lahdot
  self.primary_key = :tunnus
end
