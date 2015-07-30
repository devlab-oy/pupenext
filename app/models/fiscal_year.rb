class FiscalYear < BaseModel
  include Searchable
  include Translatable
  include SplittableDates

  self.table_name  = :tilikaudet
  self.primary_key = :tunnus

  validates :tilikausi_alku, date: { before: :tilikausi_loppu }
  validates :tilikausi_loppu, date: true

  splittable_dates :tilikausi_alku, :tilikausi_loppu

  # FIXME
  # For future reference: avaava_tase is a relationship column to lasku
  # This means FiscalYear has one lasku
  # Avaava tase functionality is not implemented yet.

  def period
    tilikausi_alku..tilikausi_loppu
  end
end
