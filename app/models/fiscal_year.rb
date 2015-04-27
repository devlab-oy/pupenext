class FiscalYear < ActiveRecord::Base
  include Searchable
  include Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name  = :tilikaudet
  self.primary_key = :tunnus

  validates :tilikausi_alku, allow_blank: false, date: true
  validates :tilikausi_loppu, allow_blank: false, date: true

  validate :times_start_before_end

  # FIXME
  # For future reference: avaava_tase is a relationship column to lasku
  # This means FiscalYear has one lasku
  # Avaava tase functionality is not implemented yet.

  def period
    tilikausi_alku..tilikausi_loppu
  end

  private

    def times_start_before_end
      return if tilikausi_alku.nil? || tilikausi_loppu.nil?
      errors.add(:tilikausi_alku, t('Tilikauden loppu on ennen alkua')) if tilikausi_loppu < tilikausi_alku
    end
end
