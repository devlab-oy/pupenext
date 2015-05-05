class FiscalYear < ActiveRecord::Base
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  # Map old database schema table to class
  self.table_name = :tilikaudet
  self.primary_key = :tunnus

  def period
    tilikausi_alku..tilikausi_loppu
  end
end
