class Accounting::FixedAssets::Commodity < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_many :rows, foreign_key: :liitostunnus, primary_key: :tunnus

  validates :nimitys, uniqueness: { scope: :yhtio }, presence: :true
  validates :summa, :sumu_poistoera, :evl_poistoera, numericality: true

  validates_presence_of :hankintapvm

  validates_presence_of :summa, :kayttoonottopvm, :sumu_poistotyyppi,
    :sumu_poistoera, :evl_poistotyyppi, :evl_poistoera, if: :activated?

  after_commit :create_rows, on: [:update, :create], if: :should_create_rows?

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

  protected

    def activated?
      tila == 'A'
    end

    def should_create_rows?
      generate_rows
    end

    def create_rows
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

    # kuukausierät
    def create_installment_rows
      full_amount = self.summa
      sumu_type = self.sumu_poistotyyppi
      sumu_amount = self.sumu_poistoera

      # poistoerät
      # T D kuukausien määrä
      # P B prosentti per vuosi

      # lasketaan määrät maksuerien perusteella

      if sumu_type == 'T'
        reductions = full_amount / sumu_amount
        calculated_sumu_amount = sumu_amount
      elsif sumu_type == 'P'
        reductions = full_amount * sumu_amount
        calculated_sumu_amount = sumu_amount
      end

      #reductions = reductions+0.5.to_i

      if reductions > 10
        reductions = 3
      end

      reductions = reductions.to_i
      activation_date = self.kayttoonottopvm
      all_row_params = []

      check = 0
      reductions.times do
        time = activation_date.advance(:months => +check)
        all_row_params<<{
          laatija: 'CommoditiesController',
          muuttaja: 'CommoditiesController',
          tapvm: time,
          yhtio: company.yhtio,
          summa: calculated_sumu_amount,
          tyyppi: self.sumu_poistotyyppi,
          tilino: self.tilino
        }
        check += 1
      end

      all_row_params
    end

    def calculate_single_depreciation(type, amount, time)
    end

end
