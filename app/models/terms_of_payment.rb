class TermsOfPayment < ActiveRecord::Base
  include AttributeSanitator
  include Validators
  include Searchable
  include Translatable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio
  has_many :customers, foreign_key: :maksuehto, primary_key: :tunnus
  has_many :sales_orders, foreign_key: :maksuehto, primary_key: :tunnus
  has_one :bank_detail, foreign_key: :tunnus, primary_key: :pankkiyhteystiedot

  validates :bank_detail, presence: true, unless: Proc.new { |t| t.pankkiyhteystiedot.nil? }
  validates :factoring, :sallitut_maat, allow_blank: true, length: { within: 1..50 }
  validates :jv, :itsetulostus, :jaksotettu, :erapvmkasin, inclusion: { in: %w(o) }, allow_blank: true
  validates :kassa_alepros, numericality: true
  validates :kateinen, inclusion: { in: %w(n o p) }, allow_blank: true
  validates :kaytossa, inclusion: { in: %w(E) }, allow_blank: true
  validates :rel_pvm, :kassa_relpvm, :jarjestys, numericality: { only_integer: true }
  validates :teksti, length: { within: 1..40 }

  validate :date_is_valid

  float_columns :kassa_alepros

  before_validation :check_relations
  before_save :defaults

  scope :in_use, -> { where(kaytossa: '') }
  scope :not_in_use, -> { where(kaytossa: 'E') }

  self.table_name = :maksuehto
  self.primary_key = :tunnus

  def cash_options
    [
      ["Tämä ei ole käteismaksuehto", ""],
      ["Käteismaksuehto, pankkikortti ei pyöristetä", "n"],
      ["Käteismaksuehto, luottokortti ei pyöristetä", "o"],
      ["Käteismaksuehto, käteinen pyöristetään", "p"]
    ]
  end

  def factoring_options
    company.factorings.select(:factoringyhtio).uniq.map(&:factoringyhtio)
  end

  def bank_details_options
    company.bank_details.map { |i| [ i.nimitys, i.id ] }
  end

  def in_use_options
    [
      ["Käytössä", ""],
      ["Poistettu / Ei käytössä", "E"]
    ]
  end

  def date_is_valid
    unless valid_date? self.abs_pvm
      errors.add(:abs_pvm, "is invalid")
    end

    unless valid_date? self.kassa_abspvm
      errors.add(:kassa_abspvm, "is invalid")
    end
  end

  private

    def check_if_in_use(obj, msg)
      count = obj.where(yhtio: yhtio).count

      if count > 0
        msg_pre = t("HUOM: Maksuehtoa ei voi poistaa, koska se on käytössä")
        errors.add(:base, "#{msg_pre} #{count} #{msg}")
      end
    end

    def check_relations
      if kaytossa?
        check_if_in_use customers, "asiakkaalla"
        check_if_in_use sales_orders.not_delivered, "toimittamattomalla myyntitilauksella"
        check_if_in_use sales_orders.not_finished, "kesken olevalla myyntitilauksella"
      end
    end

    def defaults
      self.pankkiyhteystiedot ||= 0
    end
end
