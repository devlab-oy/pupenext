class FixedAssets::Commodity < ActiveRecord::Base
  include Searchable

  # commodity = hyödyke
  # .voucher = tosite, jolle kirjataan SUMU-poistot
  # .voucher.rows = tosittella on SUMU-poisto tiliöintirivejä
  # .commodity_rows = rivejä, jolla kirjataan EVL poistot
  # .procurement_rows = tiliöintirivejä, joilla on valittu hyödykkeelle kuuluvat hankinnat

  belongs_to :company
  has_one :voucher, class_name: 'Head::Voucher'
  has_many :commodity_rows
  has_many :procurement_rows, class_name: 'Head::VoucherRow'

  validates :name, :description, presence: true
  validates :planned_depreciation_type,
            :planned_depreciation_amount,
            :btl_depreciation_type,
            :btl_depreciation_amount, presence: true, if: :activated?

  validate :only_one_account_number
  validate :activation_only_on_open_fiscal_year, if: :activated?
  validate :depreciation_amount_must_follow_type, if: :activated?
  validate :must_have_procurement_rows, if: :activated?

  before_save :set_amount, :defaults

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

  def ok_to_generate_rows?
    activated? && important_values_changed?
  end

  # Sopivat ostolaskut
  def linkable_invoices
    company.purchase_invoices_paid.find_by_account(viable_accounts)
  end

  # Sopivat tositteet
  def linkable_vouchers
    company.vouchers.commodity_linkable.find_by_account(viable_accounts)
  end

  def activated?
    status == 'A'
  end

  # Returns sum of past sumu depreciations
  def deprecated_sumu_amount
    voucher.rows.locked.sum(:summa)
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
    voucher.rows.where(tilino: fixed_assets_account)
  end

  # Poisto-tili (tuloslaskelma)
  def depreciation_account
    commodity_sum_level.try(:poistovasta_account).try(:tilino)
  end

  # Poisto-rivit
  def depreciation_rows
    voucher.rows.where(tilino: depreciation_account)
  end

  # Poistoero-tili (tase)
  def depreciation_difference_account
    commodity_sum_level.try(:poistoero_account).try(:tilino)
  end

  # Poistoero-rivit
  def depreciation_difference_rows
    voucher.rows.where(tilino: depreciation_difference_account)
  end

  # Poistoeromuutos-tili (tuloslaskelma)
  def depreciation_difference_change_account
    commodity_sum_level.try(:poistoerovasta_account).try(:tilino)
  end

  # Poistoeromuutos-rivit
  def depreciation_difference_change_rows
    voucher.rows.where(tilino: depreciation_difference_change_account)
  end

  # Kaikki hankinnan kustannuspaikat
  def procurement_cost_centres
    procurement_rows.map(&:kustp)
  end

  # Kaikki hankinnan kohteet
  def procurement_targets
    procurement_rows.map(&:kohde)
  end

  # Kaikki hankinnan projektit
  def procurement_projects
    procurement_rows.map(&:projekti)
  end

  # Kirjanpidollinen arvo annettuna ajankohtana
  def bookkeeping_value(end_date = company.current_fiscal_year.last)
    range = company.current_fiscal_year.first..end_date
    calculation = depreciation_rows.where(tapvm: range).sum(:summa)
    amount + calculation
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
      when :T
        errors.add(type, "Must be a positive number") if amount < 0
      when :P, :B
        errors.add(type, "Must be between 1-100") if amount <= 0 || amount > 100
      end
    end

    def activation_only_on_open_fiscal_year
      unless company.date_in_open_period?(activated_at)
        errors.add(:base, "Activation date must be within current editable fiscal year")
      end
    end

    def only_one_account_number
      if procurement_rows.map(&:tilino).uniq.count > 1
        errors.add(:base, "Account number must be shared between all linked cost records")
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

    def defaults
      self.planned_depreciation_type   ||= commodity_sum_level.try(:planned_depreciation_type)
      self.planned_depreciation_amount ||= commodity_sum_level.try(:planned_depreciation_amount)
      self.btl_depreciation_type       ||= commodity_sum_level.try(:btl_depreciation_type)
      self.btl_depreciation_amount     ||= commodity_sum_level.try(:btl_depreciation_amount)
    end
end
