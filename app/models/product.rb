class Product < BaseModel
  belongs_to :group, foreign_key: :osasto, primary_key: :selite, class_name: 'Product::Group'
  belongs_to :category, foreign_key: :try, primary_key: :selite, class_name: 'Product::Category'
  belongs_to :status, foreign_key: :status, primary_key: :selite, class_name: 'Keyword::Status'

  validates :tuoteno, length: { within: 1..60 }, presence: true
  validates :nimitys, length: { within: 1..100 }, presence: true

  enum ei_saldoa: {
    stored: '',
    not_stored: 'o'
  }

  self.table_name = :tuote
  self.primary_key = :tunnus

  before_create :set_date_fields

  private

    def set_date_fields
      # Date fields can be set to zero
      self.vihapvm           ||= 0
      self.epakurantti25pvm  ||= 0
      self.epakurantti50pvm  ||= 0
      self.epakurantti75pvm  ||= 0
      self.epakurantti100pvm ||= 0
    end
end
