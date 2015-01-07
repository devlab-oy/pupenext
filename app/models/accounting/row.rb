class Accounting::Row < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_one :cost_row, class_name: 'Accounting::FixedAssets::CommodityCostRow',
    foreign_key: :tiliointirivi_tunnus

  validates :tapvm, with: :date_should_be_in_current_fiscal_year
  # Map old database schema table to Accounting::Row class
  self.table_name  = :tiliointi
  self.primary_key = :tunnus

  default_scope { order(tapvm: :asc) }
  scope :active, -> { where(korjattu: '') }

  protected

    def date_should_be_in_current_fiscal_year
      errors.add(:tapvm, 'Should be within current fiscal year') unless
        company.is_date_in_this_fiscal_year?(tapvm)
    end

end
