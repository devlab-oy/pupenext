class FiscalYear < ActiveRecord::Base
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :tilikaudet
  self.primary_key = :tunnus

  validates :tilikausi_alku, presence: true, date: true
  validates :tilikausi_loppu, presence: true, date: true

  def period
    tilikausi_alku..tilikausi_loppu
  end
end
