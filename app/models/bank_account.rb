class BankAccount < ActiveRecord::Base

  include Searchable
  include BankHelper
  extend Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  with_options class_name: "Account", primary_key: :tilino do |o|
    o.belongs_to :default_liquidity_account, ->(b) { where(yhtio: b.yhtio) },
                 foreign_key: :oletus_rahatili
    o.belongs_to :default_expense_account, ->(b) { where(yhtio: b.yhtio) },
                 foreign_key: :oletus_kulutili
    o.belongs_to :default_clearing_account, ->(b) { where(yhtio: b.yhtio) },
                 foreign_key: :oletus_selvittelytili
  end

  belongs_to :default_cost_center, foreign_key: :oletus_kustp, class_name: "Qualifier::CostCenter"
  belongs_to :default_target, foreign_key: :oletus_kohde, class_name: "Qualifier::Target"
  belongs_to :default_project, foreign_key: :oletus_projekti, class_name: "Qualifier::Project"

  validates :nimi, presence: true
  validates :default_liquidity_account, presence: true
  validates :default_expense_account, presence: true
  validates :default_clearing_account,
            presence: true, unless: ->(b) { b.company.selvittelytili.present? }

  with_options unless: ->(b) { b.iban.blank? && b.bic.blank? } do |o|
    o.validates :iban,
                presence: true,
                uniqueness: { scope: :company,
                              message: "on käytössä, eli pankkitili löytyy jo järjestelmästä" }
    o.validates :bic, presence: true
    o.validate :check_iban
    o.validate :check_bic
  end

  before_validation :fix_numbers
  before_save :defaults

  self.table_name = :yriti
  self.primary_key = :tunnus

  scope :in_use, -> { where.not(kaytossa: "E") }

  def in_use?
    kaytossa != "E"
  end

  def self.kaytossa_options
    [
      [t("Käytössä"), ""],
      [t("Poistettu / Ei käytössä"), "E"]
    ]
  end

  def self.factoring_options
    [
      [t("Ei"), ""],
      [t("Kyllä"), "o"]
    ]
  end

  def self.tilinylitys_options
    [
      [t("Tilinylitys ei sallittu"), ""],
      [t("Tilinylitys sallittu"), "o"]
    ]
  end

  private

    def fix_numbers
      if iban.present? && !valid_iban?(iban)
        # Try to create iban in case user has entered old account number
        self.iban = create_iban(iban)
      end

      # NOTE Remove this after column no longer present in the database
      self.tilino = iban
    end

    def check_iban
      errors.add(:iban, "on virheellinen") unless valid_iban?(iban)
    end

    def check_bic
      errors.add(:bic, "on virheellinen") unless valid_bic?(bic)
    end

    def defaults
      self.oletus_kustp ||= 0
      self.oletus_kohde ||= 0
      self.oletus_projekti ||= 0
      self.iban ||= ""
      self.bic ||= ""
    end

end
