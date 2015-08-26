class Printer < BaseModel
  include Searchable

  validates :kirjoitin, presence: true
  validates :komento, presence: true, uniqueness: { scope: :company }, format: { without: /["'<>\\;]/ }

  before_validation do |printer|
    printer.komento.strip
    printer.kirjoitin.strip
  end

  before_save :defaults

  default_scope -> { where.not(komento: 'EDI') }

  self.table_name = :kirjoittimet
  self.primary_key = :tunnus
  self.record_timestamps = false

  enum merkisto: {
    charset_default: 0,
    charset_7bit: 1,
    charset_dos: 2,
    charset_ansi: 3,
    charset_utf8: 4,
    charset_scandic_off: 5
  }

  enum mediatyyppi: {
    media_default: '',
    media_a4: 'A4',
    media_a5: 'A5',
    media_thermal1: 'LSN149X104',
    media_thermal2: 'LSN59X40',
    media_thermal3: 'LS149X104',
    media_thermal4: 'LS59X40',
    media_receipt: 'kuittitulostin'
  }

  private

    def defaults
      self.merkisto ||= 0
      self.mediatyyppi ||= ""
    end
end
