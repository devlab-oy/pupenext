class CashRegister < ActiveRecord::Base
  include Searchable

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
  self.table_name  = "kassalipas"
  self.primary_key = "tunnus"

  private

    def check_kassa
      errors.add(:kassa, "Kassatili puuttuu tai sitä ei löydy") unless check_account(kassa)
    end

    def check_pankkikortti
      errors.add(:pankkikortti, "Pankkikorttitili puuttuu tai sitä ei löydy") unless check_account(pankkikortti)
    end

    def check_luottokortti
      errors.add(:luottokortti, "Luottokorttitili puuttuu tai sitä ei löydy") unless check_account(luottokortti)
    end

    def check_kateistilitys
      errors.add(:kateistilitys, "Kateistilitystili puuttuu tai sitä ei löydy") unless check_account(kateistilitys)
    end

    def check_kassaerotus
      errors.add(:kassaerotus, "Kassaerotustili puuttuu tai sitä ei löydy") unless check_account(kassaerotus)
    end

    def check_kateisotto
      return true unless kateisotto.present?
      errors.add(:kateisotto, "Kateisotto puuttuu tai sitä ei löydy") unless check_account(kateisotto)
    end

    def check_account(account)
      Account.find_by_tilino(account).present?
    end

end
