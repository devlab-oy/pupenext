class PackingArea < BaseModel
  include Searchable
  include UserDefinedValidations

  belongs_to :warehouse, foreign_key: :varasto

  validates :nimi, presence: true
  validates :lokero, length: { minimum: 1, maximum: 5 }
  validates :prio, presence: true, numericality: { only_integer: true }
  validates :pakkaamon_prio, presence: true, numericality: { only_integer: true }
  validates :varasto, presence: true
  validates :printteri0, presence: true
  validates :printteri1, presence: true
  validates :printteri2, presence: true
  validates :printteri3, presence: true
  validates :printteri4, presence: true
  validates :printteri6, presence: true
  validates :printteri7, presence: true

  validate :duplicate_cell, if: :lokero_changed?

  self.table_name  = :pakkaamo
  self.primary_key = :tunnus

  private

    def lokero_already_exists?
      warehouse.packing_areas.where(lokero: lokero).count > 0
    end

    def duplicate_cell
      msg = I18n.t 'errors.packing_area.duplicate_cells'
      errors.add(:base, msg) if !varasto_changed? && lokero_already_exists?
    end
end
