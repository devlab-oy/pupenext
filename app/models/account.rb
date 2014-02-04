class Account < ActiveRecord::Base

  belongs_to :company, foreign_key: :yhtio, primary_key: :yhtio

  validates :tilino, presence: true
  validates :nimi, presence: true
  validates :ulkoinen_taso, presence: true

  # Map old database schema table to Account class
  self.table_name  = "tili"
  self.primary_key = "tunnus"

  def sisainen_nimi
    if sisainen_taso == ''
      return ''
    else
      level = Level.where(taso: sisainen_taso)
      level.first[:nimi]
    end
  end

  def ulkoinen_nimi
    if ulkoinen_taso == ''
      return ''
    else
      level = Level.where(taso: ulkoinen_taso)
      level.first[:nimi]
    end
  end

  def alv_nimi
    if alv_taso == ''
      return ''
    else
      level = Level.where(taso: alv_taso)
      level.first[:nimi]
    end
  end

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

  def oletus_alv_options
    Keyword.where "laji IN ('alvulk', 'alv') AND ((selitetark_2 in ('#{Location.uniq.pluck(:maa).join("','")}') AND laji = 'alvulk') OR laji = 'alv')"
  end

end
