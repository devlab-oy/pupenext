class TermsOfPayment < BaseModel
  include AttributeSanitator
  include Searchable
  include UserDefinedValidations

  belongs_to :bank_detail, foreign_key: :pankkiyhteystiedot
  belongs_to :factoring
  belongs_to :directdebit
  has_many :translations, foreign_key: :selite, class_name: 'Keyword::TermsOfPaymentTranslation'

  validates :bank_detail, presence: true, unless: proc { |t| t.pankkiyhteystiedot.nil? || t.pankkiyhteystiedot.zero? }
  validates :jv, :itsetulostus, :jaksotettu, :erapvmkasin, inclusion: { in: %w(o) }, allow_blank: true
  validates :kassa_abspvm, :abs_pvm, date: { allow_blank: true }
  validates :kassa_alepros, numericality: true
  validates :rel_pvm, :kassa_relpvm, :jarjestys, numericality: { only_integer: true }, allow_blank: true
  validates :sallitut_maat, allow_blank: true, length: { within: 1..50 }
  validates :teksti, length: { within: 1..40 }

  validate :check_relations, if: :inactive?

  validate :check_dd_or_factoring, if: :directdebit_id?

  float_columns :kassa_alepros
  accepts_nested_attributes_for :translations, allow_destroy: true

  before_save :defaults

  scope :in_use, -> { where(kaytossa: '') }
  scope :not_in_use, -> { where(kaytossa: 'E') }

  self.table_name = :maksuehto
  self.primary_key = :tunnus

  enum kateinen: {
    not_cash: '',
    debit_card: 'n',
    credit_card: 'o',
    cash: 'p'
  }

  enum kaytossa: {
    active: '',
    inactive: 'E'
  }

  def translated_locales
    translations.map(&:kieli)
  end

  def name_translated(locale)
    translations.find_by(kieli: locale).try(:selitetark) || teksti
  end

  private

    def check_relations
      root = 'errors.terms_of_payment'

      count = company.customers.where(maksuehto: tunnus).count
      errors.add(:base, I18n.t("#{root}.in_use_customers", count: count)) unless count.zero?

      count = company.sales_orders.not_delivered.where(maksuehto: tunnus).count
      errors.add(:base, I18n.t("#{root}.in_use_sales_orders", count: count)) unless count.zero?

      count = company.sales_order_drafts.where(maksuehto: tunnus).count
      errors.add(:base, I18n.t("#{root}.in_use_sales_order_drafts", count: count)) unless count.zero?
    end

    def check_dd_or_factoring
      root = 'errors.terms_of_payment'

      if factoring_id?
        errors.add(:base, I18n.t("#{root}.dd_or_factoring"))
      end
    end

    def defaults
      self.pankkiyhteystiedot ||= 0
      self.rel_pvm ||= 0
      self.kassa_relpvm ||= 0
    end
end
