class DeliveryMethod < BaseModel
  has_many :waybills, foreign_key: :selite, primary_key: :rahtikirja, class_name: 'Keyword::Waybill'
  has_many :mode_of_transports, foreign_key: :selite, primary_key: :kuljetusmuoto, class_name: 'Keyword::ModeOfTransport'
  has_many :nature_of_transactions, foreign_key: :selite, primary_key: :kauppatapahtuman_luonne, class_name: 'Keyword::NatureOfTransaction'
  has_many :customs, foreign_key: :selite, primary_key: :poistumistoimipaikka_koodi, class_name: 'Keyword::Customs'

  validates :selite, uniqueness: true

  scope :permit_adr, -> { where(vak_kielto: '') }

  self.table_name = :toimitustapa
  self.primary_key = :tunnus

  enum nouto: {
    shipment: '',
    pickup: 'o'
  }

  enum lauantai: {
    not_saturday_delivery: '',
    saturday_delivery: 'o'
  }

  enum kuljyksikko: {
    not_transport_unit: '',
    transport_unit: 'o'
  }

  enum tulostustapa: {
    batch: 'E',
    instant: 'H',
    collective_instant: 'K',
    collective_batch: 'L',
    skip_print: 'X'
  }

  enum merahti: {
    sender_freight_contract: 'K',
    receiver_freight_contract: ''
  }

  enum logy_rahtikirjanumerot: {
    not_using_logy_waybill_numbers: '',
    use_logy_waybill_numbers: 'K'
  }

  enum extranet: {
    only_in_sales: '',
    only_in_extranet: 'K',
    both_in_sales_and_extranet: 'M'
  }

  enum kontti: {
    includes_container: '1',
    not_including_container: '0'
  }

  enum jvkielto: {
    cash_on_delivery_permitted: '',
    cash_on_delivery_prohibition: 'o'
  }

  enum erikoispakkaus_kielto: {
    special_packaging_permitted: '',
    special_packaging_prohibition: 'K'
  }

  enum ei_pakkaamoa: {
    reserve_packing_line: '0',
    not_reserving_packing_line: '1'
  }

  enum erittely: {
    no_waybill_specification: '',
    print_waybill_specification: 't',
    print_waybill_specification_per_customer: 'k'
  }

  enum uudet_pakkaustiedot: {
    package_info_entry_denied: '',
    package_info_entry_allowed: 'K'
  }

  enum kuljetusvakuutus_tyyppi: {
    use_company_default: '',
    no_transportation_insurance: 'E',
    currency_based_insurance: 'A',
    percentage_based_insurance: 'B',
    currency_based_insurance_with_discount: 'F',
    percentage_based_insurance_with_discount: 'G'
  }

  enum osoitelappu: {
    normal_label: '',
    intrade_label: 'intrade',
    compact_label: 'tiivistetty',
    simple_label: 'oslap_mg'
  }

  def sorting_point_options
    company.keywords.sorting_points.map { |i| [ i.selitetark, i.selite ] }
  end

  def adr_options(text)
    DeliveryMethod.permit_adr.shipment.map do |i|
      [ "#{text} #{i.selite}", i.selite ]
    end
  end

  def adr_prohibition_options
    [
      ["Toimitustavalla saa toimittaa VAK-tuotteita", ""],
      ["Toimitustavalla ei saa toimittaa VAK-tuotteita", "K"],
      adr_options("VAK-tuotteet toimitetaan toimitustavalla")
    ].reject {|i,_| i.empty?}
  end

  def alternative_adr_delivery_method_options
    [
      ["VAK-tuotteita ei siirretä omalle tilaukselleen", ""],
      adr_options("VAK-tuotteet siirretään omalle tilaukselleen toimitustavalla")
    ].reject {|i,_| i.empty?}
  end

  def permitted_packaging_options
    []
  end

  def carrier_options
    #company.carriers.map { |i| [ i.nimi, i.koodi ] }
  end
end
