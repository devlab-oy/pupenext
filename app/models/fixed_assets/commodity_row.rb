class FixedAssets::CommodityRow < ActiveRecord::Base
  belongs_to :commodity

  default_scope { where(amended: false) }

  validate :allow_only_open_period

  def self.locked
    where(locked: true)
  end

  def depreciation_difference
    # Tämän EVL-poiston saman kuukauden SUMU-poisto
    summa = commodity.fixed_assets_rows.find_by_tapvm(transacted_at).try(:summa) || 0.0
    summa - amount
  end

  private

    def allow_only_open_period
      unless commodity.company.date_in_open_period?(transacted_at)
        errors.add(:base, 'Must be created on open period.')
      end
    end
end
