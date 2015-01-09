class Keyword < ActiveRecord::Base
  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  scope :vat_percents, -> do
    where(laji: %w(alv alvulk))
      .where("selitetark_2 IN (?) OR laji = 'alv'", Location.countries)
  end

  # Map old database schema table to Qualifier class
  self.table_name = "avainsana"
  self.primary_key = "tunnus"

  def option_value
    "#{selite} %"
  end
end
