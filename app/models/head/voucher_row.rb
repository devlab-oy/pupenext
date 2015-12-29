class Head::VoucherRow < BaseModel
  with_options foreign_key: :ltunnus do |o|
    o.belongs_to :purchase_invoice, class_name: 'Head::PurchaseInvoice'
    o.belongs_to :purchase_order,   class_name: 'PurchaseOrder::Order'
    o.belongs_to :sales_invoice,    class_name: 'Head::SalesInvoice'
    o.belongs_to :sales_order,      class_name: 'SalesOrder::Order'
    o.belongs_to :voucher,          class_name: 'Head::Voucher'
  end

  belongs_to :account, foreign_key: :tilino, primary_key: :tilino
  belongs_to :commodity, class_name: 'FixedAssets::Commodity'

  default_scope { where(korjattu: '') }
  scope :locked, -> { where(lukko: 'X') }
  scope :unlocked, -> { where(lukko: '') }

  validates :yhtio, presence: true
  validate :allow_only_open_period
  validate :only_one_account_per_commodity, if: :has_commodity_account?
  validate :allow_only_commodity_sum_level_accounts, if: :has_commodity_id?
  validate :commodity_linking

  before_save :defaults

  self.table_name = :tiliointi
  self.primary_key = :tunnus

  def counter_entry(account_number)
    # Create a counter entry for self
    row = self.dup
    row.tilino = account_number
    row.summa *= -1
    row.selite += ' vastakirjaus'
    row.save!
  end

  def split(params)
    raise ArgumentError, 'Invalid parameters' unless split_params_valid?(params) && valid?

    # Splits one entry object into multiple objects
    new_rows = params.map do |param_row|
      # Always start with the original
      row = self.dup
      row.attributes = {
        summa: (param_row[:percent] * row.summa / 100).round(2),
        kustp: param_row[:cost_centre] || row.kustp,
        kohde: param_row[:target]      || row.kohde,
        projekti: param_row[:project]  || row.projekti
      }

      row
    end

    # Calculate and set correct amount for last row
    new_rows.last.summa = summa - (new_rows.map(&:summa).sum - new_rows.last.summa)

    new_rows_valid = new_rows.all? { |row| row.valid? }

    # Mark original removed by THE creator
    creator = company.users.find_by(kuka: laatija)
    amend_by(creator)

    if new_rows_valid && valid?
      new_rows.each { |row| row.save }
      save
    else
      raise ArgumentError, 'Invalid parameters'
    end
  end

  def amend_by(user)
    raise ArgumentError, 'Argument must be an User -class' unless user.is_a? User

    self.korjattu = user.kuka
    self.korjausaika = DateTime.now
  end

  private

    def split_params_valid?(params)
      valid_numbers = params.all? { |p| p[:percent].present? && p[:percent] > 0 }
      valid_total   = params.map { |p| p[:percent].to_f }.sum == 100

      valid_numbers && valid_total
    end

    def defaults
      self.laadittu ||= Date.today
      self.korjausaika ||= Date.today
    end

    def allow_only_open_period
      unless company.date_in_open_period?(tapvm)
        errors.add(:base, 'Must be created on open period.')
      end
    end

    def only_one_account_per_commodity
      unless commodity.fixed_assets_account == tilino
        errors.add(:base, 'Commodity already has a different account selected!')
      end
    end

    def has_commodity_account?
      commodity.try(:fixed_assets_account).present?
    end

    def allow_only_commodity_sum_level_accounts
      unless company.accounts.evl_accounts.map(&:tilino).uniq.include? "#{tilino}"
        errors.add(:tilino, 'Selected account must have commodity sumlevel set')
      end
    end

    def has_commodity_id?
      commodity_id.present?
    end

    def commodity_linking
      if commodity_id.present? && commodity_id_was.present? && commodity_id_changed?
        errors.add(:commodity_id, "Row already linked to a commodity. Can't relink!")
      end
    end
end
