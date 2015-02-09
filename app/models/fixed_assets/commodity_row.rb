class FixedAssets::CommodityRow < ActiveRecord::Base
  belongs_to :commodity

  default_scope { where(amended: false) }

  validate :allow_only_active_fiscal_period

  def self.locked
    where(locked: true)
  end

  def self.unlocked
    where(locked: false)
  end

  def depreciation_difference
    # Tämän EVL-poiston saman kuukauden SUMU-poisto
    sumu = commodity.voucher.rows.find_by_tapvm(transacted_at)
    sumu.summa - amount
  end

  private

    def allow_only_active_fiscal_period
      unless commodity.company.date_in_current_fiscal_year?(transacted_at)
        errors.add(:base, 'Must be created in current fiscal period')
      end
    end
end
