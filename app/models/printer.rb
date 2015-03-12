class Printer < ActiveRecord::Base
  include Searchable
  extend Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :komento, presence: true, allow_blank: false, uniqueness: { scope: :company },
            format: { without: /["'<>\\;]/ }
  validates :kirjoitin, presence: true, allow_blank: false
  validates :merkisto, inclusion: { in: proc { merkisto_types.to_h.values } },
            allow_blank: true
  validates :mediatyyppi, inclusion: { in: proc { mediatyyppi_types.to_h.values } },
            allow_blank: true

  before_validation do |printer|
    printer.komento.strip
    printer.kirjoitin.strip
  end

  before_save :defaults

  self.table_name = 'kirjoittimet'
  self.primary_key = 'tunnus'
  self.record_timestamps = false

  def self.merkisto_types
    [
      [t("Ei valintaa"), 0],
      ["7 Bit", 1],
      ["DOS", 2],
      ["ANSI", 3],
      ["UTF8", 4],
      ["Scandic off", 5]
    ]
  end

  def self.mediatyyppi_types
    [
      [t("Ei valintaa"), ""],
      %w(A4 A4),
      %w(A5 A5),
      ["#{t("Lämpösiirto/nauha")} 149X104mm", "LSN149X104"],
      ["#{t("Lämpösiirto/nauha")} 59X40mm", "LSN59X40"],
      ["#{t("Lämpösiirto")} 149X104mm", "LS149X104"],
      ["#{t("Lämpösiirto")} 59X40mm", "LS59X40"],
      [t("Kuittitulostin"), "kuittitulostin"]
    ]
  end

  private

    def defaults
      self.merkisto ||= 0
      self.mediatyyppi ||= ""
    end

end
