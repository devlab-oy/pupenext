class BankAccount < BaseModel
  include Searchable
  include BankHelper

  with_options class_name: "Account", primary_key: :tilino do |o|
    o.belongs_to :default_liquidity_account, foreign_key: :oletus_rahatili
    o.belongs_to :default_expense_account,   foreign_key: :oletus_kulutili
    o.belongs_to :default_clearing_account,  foreign_key: :oletus_selvittelytili
  end

  belongs_to :default_cost_center, foreign_key: :oletus_kustp,    class_name: "Qualifier::CostCenter"
  belongs_to :default_target,      foreign_key: :oletus_kohde,    class_name: "Qualifier::Target"
  belongs_to :default_project,     foreign_key: :oletus_projekti, class_name: "Qualifier::Project"

  validates :bic, presence: true
  validates :default_clearing_account,  presence: true
  validates :default_expense_account,   presence: true
  validates :default_liquidity_account, presence: true
  validates :iban, presence: true, uniqueness: { scope: :company }
  validates :nimi, presence: true

  validate :check_iban
  validate :check_bic

  before_validation :convert_to_iban
  before_save :defaults

  self.table_name = :yriti
  self.primary_key = :tunnus

  enum kaytossa: {
    active: '',
    inactive: 'E',
  }

  enum factoring: {
    factoring_disabled: '',
    factoring_enabled: 'o',
  }

  enum tilinylitys: {
    limit_override_denied: '',
    limit_override_allowed: 'o',
  }

  private

    def convert_to_iban
      # Try to create iban in case user has entered old account number
      if iban.present? && !valid_iban?(iban)
        self.iban = create_iban(iban)
      end
    end

    def check_iban
      errors.add(:iban, I18n.t('errors.messages.invalid')) unless valid_iban?(iban)
    end

    def check_bic
      errors.add(:bic, I18n.t('errors.messages.invalid')) unless valid_bic?(bic)
    end

    def defaults
      self.oletus_kustp ||= 0
      self.oletus_kohde ||= 0
      self.oletus_projekti ||= 0
      self.iban ||= ""
      self.bic ||= ""
    end
end
