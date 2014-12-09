class Accounting::FixedAssets::Commodity < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_many :rows, foreign_key: :liitostunnus, primary_key: :tunnus

  validates :nimitys, uniqueness: { scope: :yhtio }, presence: :true
  validates :summa, :sumu_poistoera, :evl_poistoera, numericality: true

  validates_presence_of :hankintapvm

  validates_presence_of :summa, :kayttoonottopvm, :sumu_poistotyyppi,
    :sumu_poistoera, :evl_poistotyyppi, :evl_poistoera, if: :activated?

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
      when 'B'
        # Degressive by percentage
      end

      activation_date = self.kayttoonottopvm
      all_row_params = []
      reductions.count.times do |amt|
        time = activation_date.advance(:months => +amt)
        all_row_params<<{
          laatija: 'CommoditiesController',
          muuttaja: 'CommoditiesController',
          tapvm: time,
          yhtio: company.yhtio,
          summa: reductions[0],
          tyyppi: self.sumu_poistotyyppi,
          tilino: self.tilino
        }
      end

      all_row_params
    end

end
