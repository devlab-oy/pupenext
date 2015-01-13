class Account < ActiveRecord::Base
  include Searchable

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  with_options primary_key: :tunnus do |o|
    o.belongs_to :project,     class_name: 'Qualifier::Project',    foreign_key: :projekti
    o.belongs_to :target,      class_name: 'Qualifier::Target',     foreign_key: :kohde
    o.belongs_to :cost_center, class_name: 'Qualifier::CostCenter', foreign_key: :kustp
  end

  with_options primary_key: :taso do |o|
    o.belongs_to :internal, class_name: 'SumLevel::Internal', foreign_key: :sisainen_taso
    o.belongs_to :external, class_name: 'SumLevel::External', foreign_key: :ulkoinen_taso
    o.belongs_to :vat,      class_name: 'SumLevel::Vat',      foreign_key: :alv_taso
    o.belongs_to :profit,   class_name: 'SumLevel::Profit',   foreign_key: :tulosseuranta_taso
  end

  validates :tilino, presence: true
  validates :tilino, uniqueness: { scope: [:yhtio] }
  validates :nimi, presence: true
  validates :ulkoinen_taso, presence: true

  # Map old database schema table to Account class
  self.table_name = :tili
  self.primary_key = :tunnus

  def toimijaliitos_options
    [
      ["Ei liitospakkoa", "0"],
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
      ["Tiliöinti muokattavissa", "0"],
      ["Tiliöinnin manuaalinen lisäys/muokkaus estetty", "X"]
    ]
  end
end
