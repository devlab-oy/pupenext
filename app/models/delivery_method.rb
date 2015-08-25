class DeliveryMethod < BaseModel
  include Searchable

  with_options foreign_key: :selite do |o|
    o.has_many :waybills,               primary_key: :rahtikirja,                 class_name: 'Keyword::Waybill'
    o.has_many :mode_of_transports,     primary_key: :kuljetusmuoto,              class_name: 'Keyword::ModeOfTransport'
    o.has_many :nature_of_transactions, primary_key: :kauppatapahtuman_luonne,    class_name: 'Keyword::NatureOfTransaction'
    o.has_many :customs,                primary_key: :poistumistoimipaikka_koodi, class_name: 'Keyword::Customs'
    o.has_many :sorting_point,          primary_key: :lajittelupiste,             class_name: 'Keyword::SortingPoint'
  end

  validates :selite, uniqueness: true
  validate :vaihtoehtoinen_vak_toimitustapa_validation
  validate :vak_kielto_validation

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

  def permitted_packaging_options
    []
  end

  private

    def permit_adr_shipments
      DeliveryMethod.permit_adr.shipment.pluck(:selite)
    end

    def vak_kielto_validation
      allowed = DeliveryMethod.permit_adr.shipment.pluck(:selite) + [ '', 'K' ]
      errors.add :vak_kielto, I18n.t('errors.messages.inclusion') unless allowed.include? vak_kielto
    end

    def vaihtoehtoinen_vak_toimitustapa_validation
      allowed = permit_adr_shipments + [ '' ]
      errors.add :vaihtoehtoinen_vak_toimitustapa, I18n.t('errors.messages.inclusion') unless allowed.include? vaihtoehtoinen_vak_toimitustapa
    end
end
