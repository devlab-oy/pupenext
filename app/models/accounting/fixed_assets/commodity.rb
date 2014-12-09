class Accounting::FixedAssets::Commodity < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_many :rows, foreign_key: :liitostunnus, primary_key: :tunnus

  validates :nimitys, uniqueness: { scope: :yhtio }, presence: :true
  validates :summa, :sumu_poistoera, :evl_poistoera, numericality: true

  validates_presence_of :hankintapvm

  validates_presence_of :summa, :kayttoonottopvm, :sumu_poistotyyppi,
    :sumu_poistoera, :evl_poistotyyppi, :evl_poistoera, if: :activated?

  validates_numericality_of :tilino, greater_than: 999, if: :activated?

  after_save :create_rows, on: [:update, :create], if: :should_create_rows?

  attr_accessor :generate_rows

  # Map old database schema table to Accounting::FixedAssets::Commodity class
  self.table_name = :kayttomaisuus_hyodyke
  self.primary_key = :tunnus

  def self.search_like(args)
    result = self.all

    args.each do |key,value|
      if exact_search? value
        value = exact_search value
        result = where(key => value)
      else
        result = where_like key, value
      end
    end

    result
  end

  def self.where_like(column, search_term)
    where(self.arel_table[column].matches "%#{search_term}%")
  end

  def self.exact_search(value)
    value[1..-1]
  end

  def self.exact_search?(value)
    value[0].to_s.include? "@"
  end

  def get_options_for_type
    [
      ['Tasapoisto kuukausittain','T'],
      ['Tasapoisto vuosiprosentti','P'],
      ['Menojäännöspoisto kuukausittain','D'],
      ['Menojäännöspoisto vuosiprosentti','B']
    ]
  end

  def get_options_for_state
    [
      ['Ei aktivoitu', ''],
      ['Aktivoitu', 'A'],
      ['Poistettu', 'P']
    ]
  end

  # Calculates monthly payments
  def divide_to_payments(full_amount, payments = 12)
    full_amount = full_amount.to_d
    return [] if full_amount.zero? || payments.zero?

    payment_amount = full_amount / payments
    payment_amount = payment_amount.round(2)
    remainder = full_amount.divmod(payment_amount)

    result = []

    remainder[0].to_i.times do |k|
      result[k] = payment_amount
    end

    unless remainder[1].zero?
      if remainder[0] < payments
        result.push remainder[1]
      else
        result[-1] += remainder[1]
      end
    end
    #logger.debug "REpost: #{result.inspect} lastamount #{last_payment_amount.to_s} remainder #{remainder[1].to_s}"
    result
  end

  protected

    def activated?
      tila == 'A'
    end

    def should_create_rows?
      generate_rows
    end

    def create_rows
      deactivate_old_rows unless rows.count.zero?
      installment_rows = create_installment_rows
      installment_rows.each do |params|
        create_row(params)
      end
    end

    def create_row(params)
      a = rows.build
      a.attributes = params
      a.save
    end

    def deactivate_old_rows
      rows.active.update_all(korjattu: 'X', korjausaika: Time.now)
    end

    def create_installment_rows
      full_amount = summa
      sumu_type = sumu_poistotyyppi
      sumu_amount = sumu_poistoera

      reductions = []

      # Calculation rules
      case sumu_type
      when 'T'
        # Fixed by months
        reductions = divide_to_payments(full_amount, sumu_amount)
      when 'P'
        # Fixed by percentage
        yearly_amount = full_amount * sumu_amount / 100
        payments = full_amount / yearly_amount * 12
        payments = payments.to_i
        reductions = divide_to_payments(full_amount, payments)
      when 'D'
        # Degressive by months
        total_number_of_payments = sumu_amount
        one_year = 12
        # Calculate first year
        first_year_reductions = divide_to_payments(full_amount, total_number_of_payments)
        reductions = first_year_reductions.take(one_year)
        remaining_payments = total_number_of_payments-one_year
        remaining_amount = full_amount - reductions.sum
        logger.debug "REpost: #{reductions.count}"
        # Calculate the rest
        until remaining_payments.zero?

          later_year_reductions = divide_to_payments(remaining_amount, remaining_payments)

          later_reductions = later_year_reductions.take(one_year)
          remaining_payments -= later_reductions.count
          remaining_amount -= later_reductions.sum

          reductions.concat later_reductions

          if remaining_payments < 1
            remaining_payments = 0
            if remaining_amount > 0
              reductions.push remaining_amount
            end
          end
          #logger.debug "lopussa later_reductions:#{later_reductions.sum} remaining: #{remaining_amount} eriajaljella=#{remaining_payments} resultcount=#{reductions.count}"
        end

      when 'B'
        # Degressive by percentage
      end

      activation_date = self.kayttoonottopvm
      all_row_params = []

      amt = 0
      reductions.each do |red|
        time = activation_date.advance(:months => +amt)
        all_row_params<<{
          laatija: 'CommoditiesController',
          muuttaja: 'CommoditiesController',
          tapvm: time,
          yhtio: company.yhtio,
          summa: red,
          tyyppi: sumu_poistotyyppi,
          selite: 'SUMU poisto',
          tilino: tilino
        }
        amt += 1
      end

      all_row_params
    end

end
