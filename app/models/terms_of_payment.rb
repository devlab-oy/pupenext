class TermsOfPayment < ActiveRecord::Base
  include AttributeSanitator
  include Validators

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_many :customers, foreign_key: :maksuehto, primary_key: :tunnus
  has_many :sales_orders, foreign_key: :maksuehto, primary_key: :tunnus

  validates :rel_pvm,
            :kassa_relpvm,
            :pankkiyhteystiedot,
            :jarjestys, numericality: { only_integer: true }

  validates :jv,
            :itsetulostus,
            :jaksotettu,
            :erapvmkasin,
            :kaytossa, presence: true, allow_blank: true, length: { is: 1 }

  validates :kateinen,
    presence: true,
    allow_blank: true,
    inclusion: { in: %w[n o p] }

  validates :teksti, presence: true, allow_blank: false, length: { within: 1..40 }
  validates :factoring, :sallitut_maat, allow_blank: true, length: { within: 1..50 }
  validates :kassa_alepros, numericality: true

  validates :abs_pvm, :kassa_abspvm, presence: true, allow_blank: true
  validate :date_is_valid

  float_columns :kassa_alepros

  before_validation :check_relations

  default_scope { where(kaytossa: '') }
  scope :not_in_use, -> { unscoped.where(kaytossa: 'E') }

  def cash_options
    [
      ["Tämä ei ole käteismaksuehto", ""],
      ["Käteismaksuehto, pankkikortti ei pyöristetä", "n"],
      ["Käteismaksuehto, luottokortti ei pyöristetä", "o"],
      ["Käteismaksuehto, käteinen pyöristetään", "p"]
    ]
  end

  def factoring_options
    ops = [["Ei factoroida", ""]]

    Factoring.where(yhtio: yhtio).select(:factoringyhtio).uniq.each do |i|
      ops << [ i.factoringyhtio, i.factoringyhtio ]
    end

    ops
  end

  def bank_details_options
    ops = [["Käytä yrityksen oletuksia", 0]]
    BankDetail.where(yhtio: yhtio).each { |i| ops << [ i.nimitys, i.id ] }
    ops
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

  def self.search_like(args)
    result = self.all

    args.each do |key,value|

      case column_type(key)
      when :integer, :decimal
        result = exact_search key, value
      else
        if exact_search? value
          value = value[1..-1]
          result = exact_search key, value
        else
          result = where_like key, value
        end
      end
    end

    result
  end

  def self.where_like(column, search_term)
    where(self.arel_table[column].matches "%#{search_term}%")
  end

  def self.exact_search(key, value)
    where(key => value)
  end

  def self.exact_search?(value)
    value[0].to_s.include? "@"
  end

  def self.column_type(column)
    columns_hash[column.to_s].type
  end

  private

    def check_if_in_use(obj, msg)
      count = obj.where(yhtio: yhtio).count

      if count > 0
        msg_pre = I18n.t("HUOM: Maksuehtoa ei voi poistaa, koska se on käytössä")
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

  self.table_name = :maksuehto
  self.primary_key = :tunnus
end
