class Keyword < BaseModel
  def self.vat_percents
    where(laji: %w(alv alvulk))
      .where("selitetark_2 IN (?) OR laji = 'alv'", Location.countries)
  end

  self.table_name = :avainsana
  self.primary_key = :tunnus

  def vat_percent_text
    "#{selite} %"
  end

  def vat_percent
    BigDecimal selite
  end
end
