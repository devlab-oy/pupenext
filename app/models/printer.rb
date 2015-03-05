class Printer < ActiveRecord::Base
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :komento, presence: true, allow_blank: false, uniqueness: { scope: :company },
            format: { without: /["'<>\\;]/ }
  validates :kirjoitin, presence: true, allow_blank: false
  validates :merkisto, inclusion: { in: proc { merkisto_types } }, allow_blank: true
  validates :mediatyyppi, inclusion: { in: proc { mediatyyppi_types } }, allow_blank: true

  before_validation do |printer|
    printer.komento.strip
    printer.kirjoitin.strip
  end

  before_save :defaults

  self.table_name = 'kirjoittimet'
  self.primary_key = 'tunnus'
  self.record_timestamps = false

  def self.merkisto_types
    (1..5).to_a
  end

  def self.mediatyyppi_types
    %w(A4 A5 LSN149X104  LSN59X40 LS149X104 LS59X40 kuittitulostin)
  end

  private

  def defaults
    self.merkisto ||= 0
    self.mediatyyppi ||= ""
  end

end
