class FixedAssets::Commodity < BaseModel
  include Searchable

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
    o.validates :planned_depreciation_type, :btl_depreciation_type, presence: true
    o.validates :planned_depreciation_amount, :btl_depreciation_amount,
                numericality: { greater_than: 0 }, presence: true

    o.validate :activation_only_on_open_period, if: :status_changed?
    o.validate :depreciation_amount_must_follow_type
    o.validate :must_have_procurement_rows
  end

  before_save :prevent_further_changes, if: :deactivated_before?
  before_save :set_amount, :defaults

  before_destroy :wipe_all_records

  def self.options_for_type
    [
      ['Valitse',''],
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def self.options_for_status
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
  end

  def previous_btl_depreciations=(value)
    write_attribute(:previous_btl_depreciations, value.to_d.abs)
  end

  def allows_unlinking?
    !activated? || procurement_rows.count > 1
  end

  def ok_to_generate_rows?
    activated? && important_values_changed?
  end

  # Sopivat ostolaskut
  def linkable_invoices
    company.purchase_invoices_paid.where(tunnus: linkable_head_ids)
  end

  # Sopivat ostolaskurivit
  def linkable_invoice_rows
    return [] unless linkable_invoices.present?
    linkable_invoices.map { |invoice| invoice.rows.where(tilino: viable_accounts, commodity_id: nil) }
  end

  # Sopivat tositteet
  def linkable_vouchers
    company.vouchers.where(tunnus: linkable_head_ids)
  end

  # Sopivat tositerivit
  def linkable_voucher_rows
    return [] unless linkable_vouchers.present?

    linkable_vouchers.map do |voucher|
      voucher_rows.where(tiliointi: { tilino: viable_accounts, commodity_id: nil })
    end
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

  # Kirjanpidollinen arvo annettuna ajankohtana
  def bookkeeping_value(end_date = company.current_fiscal_year.last)
    if deactivated?
      calculation = amount
    else
      calculation = accumulated_depreciation_at(end_date)
    end

    amount - calculation.abs
  end

  # EVL arvo annettuna ajankohtana, (previous_depreciations(-) tai amount) + evl poistorivit(-)
  def btl_value(end_date = company.current_fiscal_year.last)
    comparable_amount = previous_btl_depreciations == 0 ? amount : previous_btl_depreciations
    comparable_amount + accumulated_evl_at(end_date)
  end

  def can_be_sold?
    return false if profit_account.nil?
    return false if sales_account.nil?
    return false unless activated?
    return false if amount_sold.nil?
    return false if amount_sold < 0
    return false if deactivated_at.nil?
    return false if deactivated_at.to_date > Date.today
    return false unless company.date_in_open_period?(deactivated_at)
    return false unless ['S','E'].include?(depreciation_remainder_handling)
    true
  end

  # kertyneet sumu-poistot annettuna ajankohtana
  def accumulated_depreciation_at(date)
    depreciation_rows.where("tiliointi.tapvm <= ?", date).sum(:summa)
  end

  # kertyneet poistoerot annettuna ajankohtana
  def accumulated_difference_at(date)
    depreciation_difference_rows.where("tiliointi.tapvm <= ?", date).sum(:summa)
  end

  # kertyneet evl-poistot annettuna ajankohtana
  def accumulated_evl_at(date)
    commodity_rows.where("fixed_assets_commodity_rows.transacted_at <= ?", date).sum(:amount)
  end

  # kertyneet sumu-poistot välillä
  def depreciation_between(date_begin, date_end)
    depreciation_rows.where(tapvm: date_begin..date_end).sum(:summa)
  end

  # kertyneet poistoerot välillä
  def difference_between(date_begin, date_end)
    depreciation_difference_rows.where(tapvm: date_begin..date_end).sum(:summa)
  end

  # kertyneet evl-poistot välillä
  def evl_between(date_begin, date_end)
    commodity_rows.where(transacted_at: date_begin..date_end).sum(:amount)
  end

  # alkuperäinen hankintahinta
  def procurement_amount
    transferred_procurement_amount > 0 ? transferred_procurement_amount : amount
  end

  private

    def important_values_changed?
      attrs = %w{
        amount
        activated_at
        planned_depreciation_type
        planned_depreciation_amount
        btl_depreciation_type
        btl_depreciation_amount
      }

      (changed & attrs).any?
    end

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
        errors.add(:base, "Activation date must be within current editable fiscal period")
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
      ids = Head::VoucherRow.where(tilino: viable_accounts, commodity_id: nil).pluck(:ltunnus)
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
end
