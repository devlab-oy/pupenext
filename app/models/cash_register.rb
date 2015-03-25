class CashRegister < ActiveRecord::Base
  include Searchable
  include Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
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

  # Map old database schema table to CashRegister class
  self.table_name  = :kassalipas
  self.primary_key = :tunnus

  private

    def check_kassa
      msg = t("Kassatili puuttuu tai sitä ei löydy")
      errors.add(:kassa, msg) unless check_account(kassa)
    end

    def check_pankkikortti
      msg = t("Pankkikorttitili puuttuu tai sitä ei löydy")
      errors.add(:pankkikortti, msg) unless check_account(pankkikortti)
    end

    def check_luottokortti
      msg = t("Luottokorttitili puuttuu tai sitä ei löydy")
      errors.add(:luottokortti, msg) unless check_account(luottokortti)
    end

    def check_kateistilitys
      msg = t("Kateistilitystili puuttuu tai sitä ei löydy")
      errors.add(:kateistilitys, msg) unless check_account(kateistilitys)
    end

    def check_kassaerotus
      msg = t("Kassaerotustili puuttuu tai sitä ei löydy")
      errors.add(:kassaerotus, msg) unless check_account(kassaerotus)
    end

    def check_kateisotto
      return true unless kateisotto.present?
      msg = t("Kateisotto puuttuu tai sitä ei löydy")
      errors.add(:kateisotto, msg) unless check_account(kateisotto)
    end

    def check_account(account)
      company.accounts.find_by_tilino(account).present?
    end

end
