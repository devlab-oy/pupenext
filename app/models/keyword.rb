class Keyword < BaseModel
  def self.vat_percents
    where(laji: %w(alv alvulk))
      .where("selitetark_2 IN (?) OR laji = 'alv'", Location.countries)
  end

  self.table_name = :avainsana
  self.primary_key = :tunnus

  def option_value
    "#{selite} %"
  end
end
