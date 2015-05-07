class FiscalYear < BaseModel
  include Searchable
  include Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name  = :tilikaudet
  self.primary_key = :tunnus

  validates :tilikausi_alku, allow_blank: false, date: { before: :tilikausi_loppu }
  validates :tilikausi_loppu, allow_blank: false, date: true

  # FIXME
  # For future reference: avaava_tase is a relationship column to lasku
  # This means FiscalYear has one lasku
  # Avaava tase functionality is not implemented yet.

  def period
    tilikausi_alku..tilikausi_loppu
  end
end
