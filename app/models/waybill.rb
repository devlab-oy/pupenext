class Waybill < BaseModel
  belongs_to :delivery_method,  foreign_key: :toimitustapa, primary_key: :selite

  scope :not_printed, -> { where(tulostettu: 0) }

  self.table_name = :rahtikirjat
  self.primary_key = :tunnus
end
