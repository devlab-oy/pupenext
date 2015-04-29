class Account < BaseModel
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  has_one :commodity, class_name: 'FixedAssets::Commodity'

  with_options primary_key: :tunnus do |o|
    o.belongs_to :project,     class_name: 'Qualifier::Project',    foreign_key: :projekti
    o.belongs_to :target,      class_name: 'Qualifier::Target',     foreign_key: :kohde
    o.belongs_to :cost_center, class_name: 'Qualifier::CostCenter', foreign_key: :kustp
  end

  with_options primary_key: :taso do |o|
    o.belongs_to :internal,  class_name: 'SumLevel::Internal',  foreign_key: :sisainen_taso
    o.belongs_to :external,  class_name: 'SumLevel::External',  foreign_key: :ulkoinen_taso
    o.belongs_to :vat,       class_name: 'SumLevel::Vat',       foreign_key: :alv_taso
    o.belongs_to :profit,    class_name: 'SumLevel::Profit',    foreign_key: :tulosseuranta_taso
    o.belongs_to :commodity, class_name: 'SumLevel::Commodity', foreign_key: :evl_taso
  end

  validates :tilino, presence: true, uniqueness: { scope: [:yhtio] }
  validates :nimi, presence: true
  validates :ulkoinen_taso, presence: true

  validate :sum_level_presence

  before_save :defaults

  # Map old database schema table to Account class
  self.table_name = :tili
  self.primary_key = :tunnus

  def self.evl_accounts
    where.not(evl_taso: '')
  end

  def toimijaliitos_options
    [
      ["Ei liitospakkoa", ""],
      ["Muistiotositteelle on liitettävä asiakas tai toimittaja", "A"]
    ]
  end

  def tiliointi_tarkistus_options
    [
      ["Ei pakollisia kenttiä", "0"],
      ["Pakollisia kenttiä tiliöinnissä on kustannuspaikka", "1"],
      ["Pakollisia kenttiä tiliöinnissä on kustannuspaikka, kohde", "2"],
      ["Pakollisia kenttiä tiliöinnissä on kustannuspaikka, projekti", "3"],
      ["Pakollisia kenttiä tiliöinnissä on kustannuspaikka, kohde ja projekti", "4"],
      ["Pakollisia kenttiä tiliöinnissä on kohde", "5"],
      ["Pakollisia kenttiä tiliöinnissä on kohde, projekti", "6"],
      ["Pakollisia kenttiä tiliöinnissä on", "7"]
    ]
  end

  def manuaali_esto_options
    [
      ["Tiliöinti muokattavissa", ""],
      ["Tiliöinnin manuaalinen lisäys/muokkaus estetty", "X"]
    ]
  end

  private

    def sum_level_presence
      if sisainen_taso.present? && company.sum_level_internals.find_by(taso: sisainen_taso).blank?
        errors.add :sisainen_taso, "must be correct if present"
      end

      if ulkoinen_taso.present? && company.sum_level_externals.find_by(taso: ulkoinen_taso).blank?
        errors.add :ulkoinen_taso, "must be correct"
      end

      if alv_taso.present? && company.sum_level_vats.find_by(taso: alv_taso).blank?
        errors.add :alv_taso, "must be correct if present"
      end

      if tulosseuranta_taso.present? && company.sum_level_profits.find_by(taso: tulosseuranta_taso).blank?
        errors.add :tulosseuranta_taso, "must be correct if present"
      end
    end

    def defaults
      self.projekti ||= 0
      self.kustp ||= 0
      self.kohde ||= 0
      self.toimijaliitos ||= ""
      self.manuaali_esto ||= ""
    end
end
