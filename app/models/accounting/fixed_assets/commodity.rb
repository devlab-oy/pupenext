class Accounting::FixedAssets::Commodity < ActiveRecord::Base

  has_one :company, foreign_key: :yhtio, primary_key: :yhtio
  has_one :accounting_voucher, foreign_key: :tunnus, primary_key: :ltunnus
  has_many :rows, foreign_key: :liitostunnus, primary_key: :tunnus

  validates :nimitys, uniqueness: { scope: :yhtio }
  validates :summa, :sumu_poistoera, :evl_poistoera, numericality: true
  validates_presence_of :summa
  validates_presence_of :kayttoonottopvm, :sumu_poistotyyppi,
    :sumu_poistoera, :evl_poistotyyppi, :evl_poistoera, { scope: :activated }

  after_commit :create_rows, on: [:update, :create], if: :activated?

  # Map old database schema table to Accounting::FixedAssets::Commodity class
  self.table_name = :kayttomaisuus_hyodyke
  self.primary_key = :tunnus

  scope :activated, -> { where(tila: 'A') }

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


  protected

    def activated?
      return true if self.tila == 'A'
      false
    end

    def create_rows
      installment_rows = create_installment_rows
      installment_rows.each do |params|
        create_row(params)
      end
    end

    def create_row(params)
      a = self.rows.build
      a.attributes = params
      #a.attributes = {
      #  laatija: 'kirka',
      #  muuttaja: 'kirka',
      #  yhtio: company.yhtio
      #}
      a.save
    end

    def create_installment_rows
      [{ laatija: 'kika',
         muuttaja: 'kika',
         yhtio: company.yhtio,
         summa: 200,
         tyyppi: self.sumu_poistotyyppi}]
    end

end
