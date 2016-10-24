class Warehouse < BaseModel
  include UserDefinedValidations

  PRINTER_NUMBERS = [0, 1, 2, 3, 4, 5, 6, 7, 9, 10].freeze

  has_many :packing_areas, foreign_key: :varasto
  has_many :shelf_locations, foreign_key: :varasto

  PRINTER_NUMBERS.each do |number|
    send(:belongs_to, "printteri#{number}".to_sym, foreign_key: "printteri#{number}", class_name: 'Printer')
  end

  scope :active, -> { where.not(tyyppi: 'P') }

  self.table_name  = :varastopaikat
  self.primary_key = :tunnus
end
