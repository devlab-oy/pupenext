class SumLevel < BaseModel
  include PupenextSingleTableInheritance
  include Searchable

  self.table_name = :taso
  self.primary_key = :tunnus
  self.inheritance_column = :tyyppi

  validates :taso, presence: true
  validates :nimi, presence: true
  validates :taso, uniqueness: { scope: [:yhtio, :tyyppi] }
  validates :poisto_vastatili, :poistoero_tili, :poistoero_vastatili, presence: true, if: lambda { tyyppi == 'E' }
  validate :does_not_contain_char
  validate :summattava_tasos_in_db_and_correct_type

  before_save :defaults

  enum kumulatiivinen: {
    not_cumulative: '',
    cumulative: 'X'
  }

  enum kayttotarkoitus: {
    normal: '',
    turnover: 'M',
    purchases: 'O'
  }

  def self.default_child_instance
    child_class 'S'
  end

  def self.child_class_names
    {
      'S' => SumLevel::Internal,
      'U' => SumLevel::External,
      'A' => SumLevel::Vat,
      'B' => SumLevel::Profit,
      'E' => SumLevel::Commodity
    }
  end

  # Rails figures out paths from the model name. User model has users_path etc.
  # With STI we want to use same name for each child. Thats why we override model_name
  def self.model_name
    ActiveModel::Name.new SumLevel
  end

  def sum_level_name
    "#{taso} #{nimi}"
  end

  def summattava_taso=(summattava_taso)
    summattava_taso = '' if summattava_taso.nil?
    summattava_taso.delete!(' ')

    write_attribute(:summattava_taso, summattava_taso)
  end

  private

    def does_not_contain_char
      error = I18n.t 'errors.sum_level.invalid_char'
      errors.add :taso, error if taso.to_s.include? "Ö"
    end

    def summattava_tasos_in_db_and_correct_type
      summattavat_tasot = summattava_taso.split ","
      klass = self.class

      existing_tasos = klass.where(taso: summattavat_tasot)

      same_count = (existing_tasos.count == summattavat_tasot.count)
      error = I18n.t 'errors.sum_level.not_same_type'
      errors.add :summattava_taso, error unless same_count
    end

    def defaults
      self.oletusarvo ||= 0.0
      self.jakaja ||= 0.0
      self.kerroin ||= 0.0
    end
end
