class FixedAssets::Commodity < BaseModel

  # commodity = hyödyke
  # .voucher = hyödykkeellä on yksi tosite, jolle kirjataan SUMU-poistot
  # .voucher_rows = tosittella on SUMU-poisto-tiliöintirivejä
  # .commodity_rows = hyödykkeellä on rivejä, joilla kirjataan EVL poistot
  # .procurement_rows = hyödykkeellä on tiliöintirivejä, joilla on valittu hyödykkeelle kuuluvat hankinnat

  belongs_to :company
  belongs_to :profit_account, class_name: 'Account'
  belongs_to :sales_account, class_name: 'Account'
  belongs_to :voucher, class_name: 'Head::Voucher'

  has_many :commodity_rows
  has_many :procurement_rows, class_name: 'Head::VoucherRow'
  has_many :voucher_rows, through: :voucher, class_name: 'Head::VoucherRow', source: :rows

  validates :name, :description, presence: true

  with_options if: :activated? do |o|
    o.validates :btl_depreciation_amount, numericality: { greater_than: 0 }, presence: true
    o.validates :btl_depreciation_type, presence: true
    o.validates :planned_depreciation_amount, numericality: { greater_than: 0 }, presence: true
    o.validates :planned_depreciation_type, presence: true

    o.validate :activation_only_on_open_period, if: :status_changed?
    o.validate :depreciation_amount_must_follow_type
    o.validate :must_have_procurement_rows
  end

  before_save :prevent_further_changes, if: :deactivated_before?
  before_save :set_amount, :defaults

  before_destroy :wipe_all_records

  def previous_btl_depreciations=(value)
    write_attribute(:previous_btl_depreciations, value.to_d.abs)
  end

  def allows_unlinking?
    !activated? || procurement_rows.count > 1
  end

  # Sopivat ostolaskut
  def linkable_invoices
    company.purchase_invoices_paid.where(tunnus: linkable_head_ids)
  end

  # Sopivat ostolaskurivit
  def linkable_invoice_rows
    company.purchase_invoice_rows.where(
      lasku: { tunnus: linkable_head_ids },
      tiliointi: { tilino: viable_accounts, commodity_id: nil }
    )
  end

  # Sopivat tositteet
  def linkable_vouchers
    company.vouchers.where(tunnus: linkable_head_ids)
  end

  # Sopivat tositerivit
  def linkable_voucher_rows
    company.voucher_rows.where(
      lasku: { tunnus: linkable_head_ids },
      tiliointi: { tilino: viable_accounts, commodity_id: nil }
    )
  end

  def activated?
    status == 'A'
  end

  def deactivated?
    status == 'P'
  end

  def can_be_destroyed?
    commodity_rows.empty? && voucher_rows.empty?
  end

  def can_be_sold?
    errors.add(:profit_account, "profit account") if profit_account.nil?
    errors.add(:sales_account, "sales account") if sales_account.nil?
    errors.add(:status, 'not activated') unless activated?
    errors.add(:amount_sold, 'greater than zero') if amount_sold.nil? || amount_sold < 0
    errors.add(:deactivated_at, 'must be past') if deactivated_at.nil? || deactivated_at.to_date > Date.today
    errors.add(:base, 'dep rows not generated') unless deactivated_at.nil? || depreciations_generated_until?(deactivated_at.to_date)
    errors.add(:deactivated_at, 'deatctivated not open') unless company.date_in_open_period?(deactivated_at)
    errors.add(:depreciation_remainder_handling, 'not in selection') unless ['S','E'].include?(depreciation_remainder_handling)

    if errors.empty?
      true
    else
      false
    end
  end

  def generate_rows(fiscal_id: nil)
    CommodityRowGenerator.new(commodity_id: id, fiscal_id: fiscal_id).generate_rows
    reload
  end

  def delete_rows(fiscal_id: nil)
    CommodityRowGenerator.new(commodity_id: id, fiscal_id: fiscal_id).mark_rows_obsolete
    reload
  end

  def activate
    self.status = 'A'
    save
  end

  def sell
    if can_be_sold? && save
      CommodityRowGenerator.new(commodity_id: id).sell
      reload
    else
      false
    end
  end

  # Returns sum of past sumu depreciations
  def deprecated_sumu_amount
    voucher_rows.locked.sum(:summa)
  end

  # Returns sum of past evl depreciations
  def deprecated_evl_amount
    commodity_rows.locked.sum(:amount)
  end

  # Käyttöomaisuus-tili (tase)
  def fixed_assets_account
    procurement_rows.first.try(:tilino)
  end

  # Käyttöomaisuus-rivit
  def fixed_assets_rows
    voucher_rows.where(tilino: fixed_assets_account)
  end

  # Poisto-tili (tuloslaskelma)
  def depreciation_account
    commodity_sum_level.try(:poistovasta_account).try(:tilino)
  end

  # Poisto-rivit
  def depreciation_rows
    voucher_rows.where(tilino: depreciation_account)
  end

  # Poistoero-tili (tase)
  def depreciation_difference_account
    commodity_sum_level.try(:poistoero_account).try(:tilino)
  end

  # Poistoero-rivit
  def depreciation_difference_rows
    voucher_rows.where(tilino: depreciation_difference_account)
  end

  # Poistoeromuutos-tili (tuloslaskelma)
  def depreciation_difference_change_account
    commodity_sum_level.try(:poistoerovasta_account).try(:tilino)
  end

  # Poistoeromuutos-rivit
  def depreciation_difference_change_rows
    voucher_rows.where(tilino: depreciation_difference_change_account)
  end

  # Kaikki hankinnan kustannuspaikat
  def procurement_cost_centres
    procurement_rows.map(&:kustp).uniq
  end

  # Kaikki hankinnan kohteet
  def procurement_targets
    procurement_rows.map(&:kohde).uniq
  end

  # Kaikki hankinnan projektit
  def procurement_projects
    procurement_rows.map(&:projekti).uniq
  end

  # Ensimmäisen hankinnan päivämäärä tai nyt
  def procurement_date
    activated_at || procurement_rows.first.try(:tapvm) || Date.today
  end

  # alkuperäinen hankintahinta
  def procurement_amount
    transferred_procurement_amount > 0 ? transferred_procurement_amount : amount
  end

  # alkuperäinen EVL arvo
  def btl_amount
    previous_btl_depreciations > 0 ? previous_btl_depreciations : procurement_amount
  end

  # kirjanpidollinen arvo annettuna ajankohtana
  def bookkeeping_value(date)
    # hankintahinta miinus kaikki SUMU-poistot
    procurement_amount - accumulated_depreciation_at(date)
  end

  # EVL-arvo annettuna ajankohtana
  def btl_value(date)
    # hankintahinta miinus kaikki EVL-poistot
    procurement_amount - accumulated_evl_at(date)
  end

  # kertyneet SUMU-poistot annettuna ajankohtana
  def accumulated_depreciation_at(date)
    depreciation_between(Time.at(0), date)
  end

  # kertyneet poistoerot annettuna ajankohtana
  def accumulated_difference_at(date)
    difference_between(Time.at(0), date)
  end

  # kertyneet EVL-poistot annettuna ajankohtana
  def accumulated_evl_at(date)
    evl_between(Time.at(0), date)
  end

  # hyödykkeen SUMU-poistot aikavälillä
  def depreciation_between(date1, date2)
    total = depreciation_rows.where(tapvm: date1..date2).sum(:summa)

    # jos kysytään arvoa, joka on vanhempi kun aktivointipäivä
    # lisätään siihen vanhassa järjestelmässä tehdyt poistot
    if date1 < activated_at && transferred_procurement_amount > 0
      total += transferred_procurement_amount - amount
    end

    total
  end

  # hyödykkeen EVL-poistot aikavälillä
  def evl_between(date1, date2)
    total = commodity_rows.where(transacted_at: date1..date2).sum(:amount) * -1

    # jos kysytään arvoa, joka on vanhempi kun aktivointipäivä
    # lisätään siihen vanhassa järjestelmässä tehdyt poistot
    if date1 < activated_at && previous_btl_depreciations > 0
      total += procurement_amount - previous_btl_depreciations
    end

    total
  end

  # hyödykkeen poistoerot aikavälillä
  def difference_between(date1, date2)
    total = depreciation_difference_rows.where(tapvm: date1..date2).sum(:summa)

    # jos kysytään poistoeroa, joka on vanhempi kun aktivointipäivä
    # huomioidaan vanhan järjestelmän poistoero
    if date1 < activated_at
      procurement_difference = (transferred_procurement_amount - amount)
      btl_difference = (procurement_amount - previous_btl_depreciations)

      total = procurement_difference - btl_difference - total
    end

    total
  end

  private

    def depreciation_amount_must_follow_type
      check_amount_allowed_for_type(planned_depreciation_type, planned_depreciation_amount)
      check_amount_allowed_for_type(btl_depreciation_type, btl_depreciation_amount)
    end

    def check_amount_allowed_for_type(type, amount)
      return '' if type.nil?
      type = type.to_sym

      case type
      when :P, :B
        errors.add(type, "Must be between 1-100") if amount > 100
      end
    end

    def activation_only_on_open_period
      unless company.date_in_open_period?(activated_at)
        errors.add(:activated_at, "Activation date must be within current editable fiscal period")
      end
    end

    def viable_accounts
      # Jos tiliä ei ole valittu, otetaan kaikki EVL tilit. Muuten valittu tili.
      procurement_rows.empty? ? company.accounts.evl_accounts.select(:tilino) : procurement_rows.select(:tilino).uniq
    end

    def set_amount
      self.amount = procurement_rows.empty? ? 0 : procurement_rows.sum(:summa)
    end

    def must_have_procurement_rows
      if procurement_rows.empty?
        errors.add(:base, 'Must have procurement rows if activated')
      end
    end

    def commodity_sum_level
      company.accounts.find_by(tilino: fixed_assets_account).try(:commodity)
    end

    def linkable_head_ids
      ids = Head::VoucherRow.where(
        tilino: viable_accounts,
        commodity_id: nil,
        tapvm: company.open_period.first..company.open_period.last
      ).pluck(:ltunnus).uniq

      ids.delete(voucher_id)
      ids
    end

    def prevent_further_changes
      self.readonly!
    end

    def defaults
      self.planned_depreciation_type   ||= commodity_sum_level.try(:planned_depreciation_type)
      self.planned_depreciation_amount ||= commodity_sum_level.try(:planned_depreciation_amount)
      self.btl_depreciation_type       ||= commodity_sum_level.try(:btl_depreciation_type)
      self.btl_depreciation_amount     ||= commodity_sum_level.try(:btl_depreciation_amount)
    end

    def deactivated_before?
      deactivated? && !status_changed?
    end

    def wipe_all_records
      raise ArgumentError unless can_be_destroyed?

      procurement_rows.update_all(commodity_id: nil)
    end

    def depreciations_generated_until?(date)
      check_start = date.beginning_of_month
      check_end = date.end_of_month

      depreciation_rows.where(tapvm: check_start..check_end).count > 0
    end
end
