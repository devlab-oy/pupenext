class Account < BaseModel
  include Searchable
  include UserDefinedValidations

  belongs_to :project,     class_name: 'Qualifier::Project',    foreign_key: :projekti
  belongs_to :target,      class_name: 'Qualifier::Target',     foreign_key: :kohde
  belongs_to :cost_center, class_name: 'Qualifier::CostCenter', foreign_key: :kustp

  has_many :commodities, through: :voucher_rows, class_name: 'FixedAssets::Commodity', source: :commodity
  has_many :voucher_rows,                        class_name: 'Head::VoucherRow', foreign_key: :tilino, primary_key: :tilino
  has_many :vouchers, through: :voucher_rows,    class_name: 'Head::Voucher', source: :voucher

  with_options primary_key: :taso do |o|
    o.belongs_to :internal,  class_name: 'SumLevel::Internal',  foreign_key: :sisainen_taso
    o.belongs_to :external,  class_name: 'SumLevel::External',  foreign_key: :ulkoinen_taso
    o.belongs_to :vat,       class_name: 'SumLevel::Vat',       foreign_key: :alv_taso
    o.belongs_to :profit,    class_name: 'SumLevel::Profit',    foreign_key: :tulosseuranta_taso
    o.belongs_to :commodity, class_name: 'SumLevel::Commodity', foreign_key: :evl_taso
  end

  validates :tilino, presence: true, uniqueness: { scope: [:yhtio] }
  validates :nimi, presence: true
  validates :ulkoinen_taso, presence: true

  validate :sum_level_presence

  before_save :defaults

  self.table_name = :tili
  self.primary_key = :tunnus

  enum toimijaliitos: {
    relation_not_required: '',
    relation_required: 'A'
  }

  enum tiliointi_tarkistus: {
    no_mandatory_fields: 0,
    mandatory_cs: 1,
    mandatory_cs_target: 2,
    mandatory_cs_project: 3,
    mandatory_cs_target_project: 4,
    mandatory_target: 5,
    mandatory_target_project: 6,
    mandatory_project: 7
  }

  enum manuaali_esto: {
    editing_enabled: '',
    editing_disabled: 'X'
  }

  def self.evl_accounts
    where.not(evl_taso: '')
  end

  def tilino_nimi
    "#{tilino} - #{nimi}"
  end

  def self.profit_and_loss_accounts
    where("ulkoinen_taso LIKE ?", "3%")
  end

  def self.balance_sheet_accounts
    where("LEFT(ulkoinen_taso, 1) < ?", "3")
  end

  private

    def sum_level_presence
      if sisainen_taso.present? && company.sum_level_internals.find_by(taso: sisainen_taso).blank?
        errors.add :sisainen_taso, I18n.t('errors.messages.invalid')
      end

      if ulkoinen_taso.present? && company.sum_level_externals.find_by(taso: ulkoinen_taso).blank?
        errors.add :ulkoinen_taso, I18n.t('errors.messages.invalid')
      end

      if alv_taso.present? && company.sum_level_vats.find_by(taso: alv_taso).blank?
        errors.add :alv_taso, I18n.t('errors.messages.invalid')
      end

      if tulosseuranta_taso.present? && company.sum_level_profits.find_by(taso: tulosseuranta_taso).blank?
        errors.add :tulosseuranta_taso, I18n.t('errors.messages.invalid')
      end
    end

    def defaults
      self.projekti ||= 0
      self.kustp ||= 0
      self.kohde ||= 0
      self.toimijaliitos ||= ""
      self.manuaali_esto ||= ""
    end
end
