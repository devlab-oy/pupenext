class Printer < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :komento, presence: true, allow_blank: false, uniqueness: { scope: :company },
            format: { without: /["'<>\\;]/ }
  validates :kirjoitin, presence: true, allow_blank: false
  validates :merkisto, inclusion: { in: proc { Printer.merkisto_types.keys } }
  validates :mediatyyppi, inclusion: { in: proc { Printer.mediatyyppi_types.keys } }

  before_validation do |printer|
    printer.komento.strip
    printer.kirjoitin.strip
  end

  self.table_name = 'kirjoittimet'
  self.primary_key = 'tunnus'
  self.record_timestamps = false

  def self.merkisto_types
    {
      0 => 'Ei valintaa',
      1 => '7 Bit',
      2 => 'DOS',
      3 => 'ANSI',
      4 => 'UTF8',
      5 => 'Scandic off'
    }
  end

  def self.mediatyyppi_types
    {
      'A4' => 'A4',
      'A5' => 'A5',
      'LSN149X104' => 'Lämpösiirto/nauha 149X104mm',
      'LSN59X40' => 'Lämpösiirto/nauha 59X40mm',
      'LS149X104' => 'Lämpösiirto 149X104mm',
      'LS59X40' => 'Lämpösiirto 59X40mm',
    }
  end

end
