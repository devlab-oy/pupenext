class Country < ActiveRecord::Base
  self.table_name  = :maat
  self.primary_key = :tunnus

  def self.unique_codes_and_names
    where.not(koodi: '')
    .where.not(nimi: '')
    .select(:koodi, :nimi)
    .distinct
    .order(:nimi)
  end
end
