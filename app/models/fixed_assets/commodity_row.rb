class FixedAssets::CommodityRow < ActiveRecord::Base
  belongs_to :commodity

  validate :allow_only_active_fiscal_period

  default_scope { where(amended: false) }

  def allow_only_active_fiscal_period
    unless commodity.company.date_in_current_fiscal_year?(transacted_at)
      errors.add(:base, 'Must be created in current fiscal period')
    end
  end

  def self.locked
    where(locked: true)
  end

  def self.unlocked
    where(locked: false)
  end

end
