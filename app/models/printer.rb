class Printer < ActiveRecord::Base
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :komento, presence: true, allow_blank: false, uniqueness: { scope: :company },
            format: { without: /["'<>\\;]/ }
  validates :kirjoitin, presence: true, allow_blank: false
  validates :merkisto, inclusion: { in: proc { Printer.merkisto_types.to_h.values } }
  validates :mediatyyppi, inclusion: { in: proc { Printer.mediatyyppi_types.to_h.values } }

  before_validation do |printer|
    printer.komento.strip
    printer.kirjoitin.strip
  end

  self.table_name = 'kirjoittimet'
  self.primary_key = 'tunnus'
  self.record_timestamps = false

  def self.merkisto_types
    [
      ["Ei valintaa", 0],
      ["7 Bit", 1],
      ["DOS", 2],
      ["ANSI", 3],
      ["UTF8", 4],
      ["Scandic off", 5]
    ]
  end

  def self.mediatyyppi_types
    [
      ["Ei valintaa", ""],
      %w(A4 A4),
      %w(A5 A5),
      ["Lämpösiirto/nauha 149X104mm", "LSN149X104"],
      ["Lämpösiirto/nauha 59X40mm", "LSN59X40"],
      ["Lämpösiirto 149X104mm", "LS149X104"],
      ["Lämpösiirto 59X40mm", "LS59X40"],
      %w(Kuittitulostin kuittitulostin)
    ]
  end

end
