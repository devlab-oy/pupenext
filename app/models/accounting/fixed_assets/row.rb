class Accounting::FixedAssets::Row < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  belongs_to :commodity, foreign_key: :tunnus, primary_key: :liitostunnus
  belongs_to :accounting_account, foreign_key: :tilino, primary_key: :tilino

  validates_numericality_of :tilino, greater_than: 999

  validates :tapvm, with: :date_should_be_in_current_fiscal_year

  # Map old database schema table to Accounting::FixedAssets::Row class
  self.table_name = :kayttomaisuus_poistoera
  self.primary_key = :tunnus

  default_scope { order(tapvm: :asc) }
  scope :active, -> { where(korjattu: '') }
  scope :locked, -> { where(lukko: 'X') }

  protected

    def date_should_be_in_current_fiscal_year
      errors.add(:tapvm, 'Should be within current fiscal year') unless company.is_date_in_this_fiscal_year?(tapvm)
    end

end
