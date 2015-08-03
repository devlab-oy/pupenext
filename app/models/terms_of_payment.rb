class TermsOfPayment < BaseModel
  include AttributeSanitator
  include Searchable

  belongs_to :bank_detail, foreign_key: :pankkiyhteystiedot, primary_key: :tunnus

  validates :bank_detail, presence: true, unless: Proc.new { |t| t.pankkiyhteystiedot.nil? }
  validates :factoring, :sallitut_maat, allow_blank: true, length: { within: 1..50 }
  validates :jv, :itsetulostus, :jaksotettu, :erapvmkasin, inclusion: { in: %w(o) }, allow_blank: true
  validates :kassa_abspvm, :abs_pvm, date: { allow_blank: true }
  validates :kassa_alepros, numericality: true
  validates :kateinen, inclusion: { in: %w(n o p) }, allow_blank: true
  validates :kaytossa, inclusion: { in: %w(E) }, allow_blank: true
  validates :rel_pvm, :kassa_relpvm, :jarjestys, numericality: { only_integer: true }
  validates :teksti, length: { within: 1..40 }

  validate :check_relations, if: :not_in_use?

  float_columns :kassa_alepros

  before_save :defaults

  scope :in_use, -> { where(kaytossa: '') }
  scope :not_in_use, -> { where(kaytossa: 'E') }

  self.table_name = :maksuehto
  self.primary_key = :tunnus

  def cash_options
    [
      [t("Tämä ei ole käteismaksuehto"), ""],
      [t("Käteismaksuehto, pankkikortti ei pyöristetä"), "n"],
      [t("Käteismaksuehto, luottokortti ei pyöristetä"), "o"],
      [t("Käteismaksuehto, käteinen pyöristetään"), "p"]
    ]
  end

  def factoring_options
    company.factorings.select(:factoringyhtio, :yhtio).uniq.map(&:factoringyhtio)
  end

  def bank_details_options
    company.bank_details.map { |i| [ i.nimitys, i.id ] }
  end

  def in_use_options
    [
      [t("Käytössä"), ""],
      [t("Poistettu / Ei käytössä"), "E"]
    ]
  end

  def not_in_use?
    kaytossa == 'E'
  end

  private

    def check_if_in_use(obj, msg)
      count = obj.where(maksuehto: tunnus).count

      if count > 0
        msg_pre = t("HUOM: Maksuehtoa ei voi poistaa, koska se on käytössä")
        errors.add(:base, "#{msg_pre} #{count} #{t(msg)}")
      end
    end

    def check_relations
      check_if_in_use company.customers, "asiakkaalla"
      check_if_in_use company.sales_orders.not_delivered, "toimittamattomalla myyntitilauksella"
      check_if_in_use company.sales_order_drafts, "kesken olevalla myyntitilauksella"
    end

    def defaults
      self.pankkiyhteystiedot ||= 0
    end
end
