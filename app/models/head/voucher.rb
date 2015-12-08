class Head::Voucher < Head
  has_one :commodity, class_name: 'FixedAssets::Commodity'
  has_many :rows, foreign_key: :ltunnus, class_name: 'Head::VoucherRow'

  validates :tila, inclusion: { in: ['X'] }

  scope :opening_balance, -> { where(alatila: :T) }
  scope :exclude_opening_balance, -> { where.not(alatila: :T) }

  # Rails requires sti_name method to return type column (tyyppi) value
  def self.sti_name
    "X"
  end

  def self.find_by_account(account_no)
    joins(:rows).where(tiliointi: { tilino: account_no })
  end
end
