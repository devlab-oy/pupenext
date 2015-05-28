class Keyword < BaseModel
  def self.vat_percents
    where(laji: %w(alv alvulk))
      .where("selitetark_2 IN (?) OR laji = 'alv'", Location.countries)
  end

  def self.waybills
    where(laji: "RAHTIKIRJA")
  end

  def self.mode_of_transports
    where(laji: "KM")
  end

  def self.nature_of_transactions
    where(laji: "KT")
  end

  def self.customs
    where(laji: "TULLI")
  end

  def self.sorting_points
    where(laji: "TOIMTAPALP")
  end

  self.table_name = :avainsana
  self.primary_key = :tunnus

  def option_value
    "#{selite} %"
  end
end
