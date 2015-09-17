class DeliveryMethod < BaseModel
  include AttributeSanitator
  include Searchable

  with_options foreign_key: :selite do |o|
    o.has_many :waybills,               primary_key: :rahtikirja,                 class_name: 'Keyword::Waybill'
    o.has_many :mode_of_transports,     primary_key: :kuljetusmuoto,              class_name: 'Keyword::ModeOfTransport'
    o.has_many :nature_of_transactions, primary_key: :kauppatapahtuman_luonne,    class_name: 'Keyword::NatureOfTransaction'
    o.has_many :customs,                primary_key: :poistumistoimipaikka_koodi, class_name: 'Keyword::Customs'
    o.has_many :sorting_point,          primary_key: :lajittelupiste,             class_name: 'Keyword::SortingPoint'
  end

  validates :selite, uniqueness: true, length: { within: 1..50 }
  validates :lahdon_selite, :sallitut_alustat, length: { within: 1..150 }, allow_blank: true
  validates :rahti_tuotenumero, :rahtikirjakopio_email, :kuljetusvakuutus_tuotenumero, :toim_nimi,
            :toim_nimitark, length: { within: 1..60 }, allow_blank: true
  validates :sopimusnro, :sallitut_maat, length: { within: 1..50 }, allow_blank: true
  validates :jarjestys, numericality: { only_integer: true }, allow_blank: true
  validates :toim_ovttunnus, length: { within: 1..25 }, allow_blank: true
  validates :toim_osoite, length: { within: 1..55 }, allow_blank: true
  validates :toim_postino, length: { within: 1..15 }, allow_blank: true
  validates :toim_postitp, :toim_maa, length: { within: 1..35 }, allow_blank: true
  validates :maa_maara, :sisamaan_kuljetus_kansallisuus, :aktiivinen_kuljetus_kansallisuus,
            length: { within: 1..2 }, allow_blank: true
  validates :sisamaan_kuljetus, :aktiivinen_kuljetus, length: { within: 1..30 }, allow_blank: true

  validate :vaihtoehtoinen_vak_toimitustapa_validation
  validate :vak_kielto_validation
  validate :mandatory_new_packaging_information if :package_info_entry_denied && :collective_batch

  before_save :defaults
  before_destroy :check_relations

  float_columns :jvkulu, :erilliskasiteltavakulu, :kuljetusvakuutus, :kuluprosentti, :ulkomaanlisa,
                :lisakulu, :lisakulu_summa

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
    receiver_freight_contract: '',
    sender_freight_contract: 'K',
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
    not_including_container: '0',
    includes_container: '1',
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

    def mandatory_new_packaging_information
      if rahtikirja.include? 'rahtikirja_unifaun'
        errors.add :base, I18n.t("errors.delivery_method.unifaun_info_missing")
      end
    end

    def vak_kielto_validation
      allowed = DeliveryMethod.permit_adr.shipment.pluck(:selite) + [ '', 'K' ]

      unless allowed.include? vak_kielto
        errors.add :vak_kielto, I18n.t('errors.messages.inclusion')
      end
    end

    def vaihtoehtoinen_vak_toimitustapa_validation
      allowed = DeliveryMethod.permit_adr.shipment.pluck(:selite) + [ '' ]

      unless allowed.include? vaihtoehtoinen_vak_toimitustapa
        errors.add :vaihtoehtoinen_vak_toimitustapa, I18n.t('errors.messages.inclusion')
      end
    end

    def check_relations
      allow_delete = true

      count = company.customers.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_customers", count: count)
        allow_delete = false
      end

      count = company.sales_orders.not_delivered.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_sales_orders", count: count)
        allow_delete = false
      end

      count = company.sales_order_drafts.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_sales_order_drafts", count: count)
        allow_delete = false
      end

      count = company.freights.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_freights", count: count)
        allow_delete = false
      end

      count = company.freight_contracts.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_freight_contracts", count: count)
        allow_delete = false
      end

      count = company.customer_keywords.where(avainsana: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_customer_keywords", count: count)
        allow_delete = false
      end

      allow_delete
    end

    def defaults
      self.kauppatapahtuman_luonne ||= 0
      self.kuljetusmuoto ||= 0
      self.sisamaan_kuljetusmuoto ||= 0
    end
end
