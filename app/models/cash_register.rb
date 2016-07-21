class CashRegister < BaseModel
  include Searchable
  include UserDefinedValidations

  validates :nimi, presence: true, uniqueness: true
  validates :kassa, presence: true
  validates :pankkikortti, presence: true
  validates :luottokortti, presence: true
  validates :kateistilitys, presence: true
  validates :kassaerotus, presence: true

  validate :check_kassa
  validate :check_pankkikortti
  validate :check_luottokortti
  validate :check_kateistilitys
  validate :check_kassaerotus
  validate :check_kateisotto

  self.table_name  = :kassalipas
  self.primary_key = :tunnus

  before_save :defaults

  private

    def check_kassa
      msg = I18n.t('errors.cash_register.kassa_missing')
      errors.add(:kassa, msg) unless check_account(kassa)
    end

    def check_pankkikortti
      msg = I18n.t('errors.cash_register.pankkikortti_missing')
      errors.add(:pankkikortti, msg) unless check_account(pankkikortti)
    end

    def check_luottokortti
      msg = I18n.t('errors.cash_register.luottokortti_missing')
      errors.add(:luottokortti, msg) unless check_account(luottokortti)
    end

    def check_kateistilitys
      msg = I18n.t('errors.cash_register.kateistilitys_missing')
      errors.add(:kateistilitys, msg) unless check_account(kateistilitys)
    end

    def check_kassaerotus
      msg = I18n.t('errors.cash_register.kassaerotus_missing')
      errors.add(:kassaerotus, msg) unless check_account(kassaerotus)
    end

    def check_kateisotto
      return true unless kateisotto.present?
      msg = I18n.t('errors.cash_register.kateisotto_missing')
      errors.add(:kateisotto, msg) unless check_account(kateisotto)
    end

    def check_account(account)
      company.accounts.find_by_tilino(account).present?
    end

    def defaults
      self.kustp       ||= 0
      self.toimipaikka ||= 0
    end
end
