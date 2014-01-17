class CashBox < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :nimi, presence: true
  #validates :kustp, presence: true
  validates :toimipaikka, presence: true
  #validates :kassa, presence: true
  #validates :pankkikortti, presence: true
  #validates :luottokortti, presence: true
  #validates :kateistilitys, presence: true
  #validates :kassaerotus, presence: true

  validate :check_kassa
  validate :check_pankkikortti
  validate :check_luottokortti
  validate :check_kateistilitys
  validate :check_kassaerotus


  before_create :update_created
  before_update :update_modified

  # Map old database schema table to CashBox class
  self.table_name  = "kassalipas"
  self.primary_key = "tunnus"
  self.record_timestamps = false

  private

    def update_created
      self.created_at = DateTime.now
      self.updated_at = DateTime.now
      if self.kustp == nil
        self.kustp = 0
      end
    end

    def update_modified
      self.updated_at = DateTime.now
      if self.kustp == nil
        self.kustp = 0
      end
    end

    def check_kassa
      errors.add(:base, "Kassatili puuttuu tai sitä ei löydy") unless check_account(kassa)
    end

    def check_pankkikortti
      errors.add(:base, "Pankkikorttitili puuttuu tai sitä ei löydy") unless check_account(pankkikortti)
    end

    def check_luottokortti
      errors.add(:base, "Luottokorttitili puuttuu tai sitä ei löydy") unless check_account(luottokortti)
    end

    def check_kateistilitys
      errors.add(:base, "Kateistilitystili puuttuu tai sitä ei löydy") unless check_account(kateistilitys)
    end

    def check_kassaerotus
      errors.add(:base, "Kassaerotustili puuttuu tai sitä ei löydy") unless check_account(kassaerotus)
    end

    def check_account(account)
        if Account.where( tilino: account).blank?
          return false
        else
          return true
        end
    end

end
