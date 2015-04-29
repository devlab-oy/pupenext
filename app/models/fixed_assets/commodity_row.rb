class FixedAssets::CommodityRow < ActiveRecord::Base
  include CurrentCompany

  belongs_to :commodity

  default_scope { where(amended: false) }

  validate :allow_only_open_fiscal_period

  def self.locked
    where(locked: true)
  end

  def depreciation_difference
    # Tämän EVL-poiston saman kuukauden SUMU-poisto
    sumu = commodity.voucher.rows.find_by_tapvm(transacted_at)
    sumu.summa - amount
  end

  private

    def allow_only_open_fiscal_period
      unless commodity.company.date_in_open_period?(transacted_at)
        errors.add(:base, 'Must be created on an open fiscal period.')
      end
    end
end
