class BankAccount < BaseModel
  include Searchable
  include BankHelper
  include UserDefinedValidations

  with_options class_name: "Account", primary_key: :tilino do |o|
    o.belongs_to :default_liquidity_account, foreign_key: :oletus_rahatili
    o.belongs_to :default_expense_account,   foreign_key: :oletus_kulutili
    o.belongs_to :default_clearing_account,  foreign_key: :oletus_selvittelytili
  end

  belongs_to :default_cost_center, foreign_key: :oletus_kustp,    class_name: "Qualifier::CostCenter"
  belongs_to :default_target,      foreign_key: :oletus_kohde,    class_name: "Qualifier::Target"
  belongs_to :default_project,     foreign_key: :oletus_projekti, class_name: "Qualifier::Project"

  validates :default_clearing_account,  presence: true
  validates :default_expense_account,   presence: true
  validates :default_liquidity_account, presence: true
  validates :iban, presence: true, uniqueness: { scope: :company }
  validates :nimi, presence: true
  validates :tilino, uniqueness: { scope: :company }
  validates :valkoodi, presence: true

  validate :check_iban
  validate :check_bic
  validate :check_tilino

  before_validation :convert_to_iban
  before_validation :convert_to_tilino

  after_initialize :initial_values
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

    def finnish_account?
      iban.first(2).upcase == 'FI'
    end

    def finnish_company?
      company.maa == 'FI'
    end

    def convert_to_iban
      if iban.blank? && tilino.present?
        number = create_iban(tilino)
        self.iban = number if valid_iban?(number)
      end
    end

    def convert_to_tilino
      if tilino.blank? && iban.present? && finnish_account?
        number = iban.last(-4)
        self.tilino = number if valid_account_number?(number)
      end
    end

    def check_iban
      if finnish_company? && !valid_iban?(iban)
        errors.add :iban, I18n.t('errors.messages.invalid')
      end
    end

    def check_bic
      return if iban =~ /\A[a-zA-Z öäåÖÄÅ]+\z/

      if finnish_company? && !valid_bic?(bic)
        errors.add :bic, I18n.t('errors.messages.invalid')
      end
    end

    def check_tilino
      if finnish_account? && finnish_company? && !valid_account_number?(tilino)
        errors.add(:tilino, I18n.t('errors.messages.invalid'))
      end
    end

    def defaults
      self.oletus_kustp ||= 0
      self.oletus_kohde ||= 0
      self.oletus_projekti ||= 0
      self.iban ||= ""
      self.bic ||= ""
    end

    def initial_values
      self.oletus_selvittelytili = company.selvittelytili if oletus_selvittelytili.blank?
    end
end
