class PackingArea < BaseModel
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  validates :lokero, presence: true
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

  # Map old database schema table to Qualifier class
  self.table_name  = :pakkaamo
  self.primary_key = :tunnus

  private

    def lokero_already_exists?
      company.packing_areas.where(varasto: varasto, lokero: lokero).count > 0
    end

    def duplicate_cell
      msg = I18n.t 'errors.picking_area.duplicate_cells'
      errors.add(:base, msg) if !varasto_changed? && lokero_already_exists?
    end
end
