class TermsOfPayment < ActiveRecord::Base

  extend AttributeSanitator
  include Validators

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_many :customers, foreign_key: :maksuehto, primary_key: :tunnus
  has_many :sales_orders, foreign_key: :maksuehto, primary_key: :tunnus

  validates :rel_pvm,
            :kassa_relpvm,
            :pankkiyhteystiedot,
            :jarjestys, numericality: { only_integer: true }

  validates :jv,
            :kateinen,
            :itsetulostus,
            :jaksotettu,
            :erapvmkasin,
            :kaytossa, presence: true, allow_blank: true, length: { is: 1 }

  validates :teksti, presence: true, allow_blank: false, length: { within: 1..40 }
  validates :factoring, :sallitut_maat, allow_blank: true, length: { within: 1..50 }
  validates :kassa_alepros, numericality: true
  validates :yhtio, presence: true

  validates :abs_pvm, :kassa_abspvm, presence: true, allow_blank: true
  validate :date_is_valid

  float_columns :kassa_alepros

  before_validation :check_if_in_use

  default_scope { where(kaytossa: '') }
  scope :not_in_use, -> { unscoped.where(kaytossa: 'E') }

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

    def check_if_in_use
      if kaytossa?
        msg_pre = 'HUOM: Maksuehtoa ei voi poistaa, koska se on käytössä'

        if customers.where(yhtio: yhtio).present?
          msg_post = 'asiakkaalla'
          _count = customers.where(yhtio: yhtio).count
          errors.add(:base, "#{msg_pre} #{_count} #{msg_post}")
        end

        if sales_orders.not_delivered.where(yhtio: yhtio).present?
          msg_post = 'toimittamattomalla myyntitilauksella'
          _count = sales_orders.not_delivered.where(yhtio: yhtio).count
          errors.add(:base, "#{msg_pre} #{_count} #{msg_post}")
        end

        if sales_orders.not_finished.where(yhtio: yhtio).present?
          msg_post = 'kesken olevalla myyntitilauksella'
          _count = sales_orders.not_finished.where(yhtio: yhtio).count
          errors.add(:base, "#{msg_pre} #{_count} #{msg_post}")
        end
      end
    end

  self.table_name = :maksuehto
  self.primary_key = :tunnus
  self.record_timestamps = false

end
