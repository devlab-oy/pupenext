class FiscalYear < BaseModel
  include Searchable
  include Translatable

  self.table_name  = :tilikaudet
  self.primary_key = :tunnus

  validates :tilikausi_alku, date: { before: :tilikausi_loppu }
  validates :tilikausi_loppu, date: true

  # FIXME
  # For future reference: avaava_tase is a relationship column to lasku
  # This means FiscalYear has one lasku
  # Avaava tase functionality is not implemented yet.

  def period
    tilikausi_alku..tilikausi_loppu
  end

  def tilikausi_alku=(value)
    if value.is_a? Hash
      value = [value[:year], value[:month], value[:day]].join '-'
    end

    write_attribute(:tilikausi_alku, value)
  end

  def tilikausi_loppu=(value)
    if value.is_a? Hash
      value = [value[:year], value[:month], value[:day]].join '-'
    end

    write_attribute(:tilikausi_loppu, value)
  end
end
