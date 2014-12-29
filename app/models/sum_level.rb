class SumLevel < ActiveRecord::Base
  #With Searchable one can do LIKE search on db
  extend Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  self.table_name = :taso
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  validates :taso, presence: true
  validates :nimi, presence: true
  validates :tyyppi, inclusion: { in: proc { SumLevel.sum_levels.keys.collect(&:to_s) } }
  validates :kumulatiivinen, inclusion: { in: proc { SumLevel.kumulatiivinen_options.keys } }
  validates :kayttotarkoitus, inclusion: { in: proc { SumLevel.kayttotarkoitus_options.keys } }
  validates :taso,
            uniqueness: { scope: [:yhtio, :tyyppi], message: t("is already defined for this type") }
  validate :does_not_contain_char
  validate :summattava_tasos_in_db_and_correct_type

  before_save :defaults

  def sum_level_name
    "#{taso} #{nimi}"
  end

  def summattava_taso=(summattava_taso)
    summattava_taso = '' if summattava_taso.nil?
    summattava_taso.delete!(' ')

    write_attribute(:summattava_taso, summattava_taso)
  end

  def self.kumulatiivinen_options
    {
      '' => t('Ei'),
      'X' => t('Kyllä Tulosseurannassa tämä taso lasketaan tilikauden alusta'),
    }
  end

  def self.kayttotarkoitus_options
    {
      '' => t('Ei valintaa'),
      'M' => t('Liikevaihto'),
      'O' => t('Ostot, Aineet, tarvikkeet ja tavarat'),
    }
  end

  def self.child_class(tyyppi_value)
    sum_levels[tyyppi_value.to_sym]
  end

  def self.default_child_instance
    child_class :S
  end

  def self.sum_levels
    {
      S: SumLevel::Internal,
      U: SumLevel::External,
      A: SumLevel::Vat,
      B: SumLevel::Profit,
    }
  end

  # This functions purpose is to return the child class name.
  # Aka. it should allways return .constantize
  # This function is called from   persistence.rb function: instantiate
  #                             -> inheritance.rb function: discriminate_class_for_record
  # This is the reason we need to map the db column with correct child class in this model
  # type_name = "S", type_name = "U" ...
  def self.find_sti_class(taso_value)
    child_class taso_value
  end

  private

    def does_not_contain_char
      errors.add :taso, "can not contain Ö" if taso.to_s.include? "Ö"
    end

    def summattava_tasos_in_db_and_correct_type
      summattavat_tasot = summattava_taso.split ","
      klass = self.class

      existing_tasos = klass.where(taso: summattavat_tasot)

      same_count = (existing_tasos.count == summattavat_tasot.count)
      err = "needs to be in db and same type"
      errors.add :summattava_taso, err unless same_count
    end

    def defaults
      self.oletusarvo ||= 0.0
      self.jakaja ||= 0.0
      self.kerroin ||= 0.0
    end
end
