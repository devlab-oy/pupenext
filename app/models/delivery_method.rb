class DeliveryMethod < BaseModel
  include AttributeSanitator
  include Searchable

  attr_accessor :flash_notice

  with_options foreign_key: :selite do |o|
    o.has_many :customs,                primary_key: :poistumistoimipaikka_koodi, class_name: 'Keyword::Customs'
    o.has_many :mode_of_transports,     primary_key: :kuljetusmuoto,              class_name: 'Keyword::ModeOfTransport'
    o.has_many :nature_of_transactions, primary_key: :kauppatapahtuman_luonne,    class_name: 'Keyword::NatureOfTransaction'
    o.has_many :sorting_point,          primary_key: :lajittelupiste,             class_name: 'Keyword::SortingPoint'
    o.has_many :translations,                                                     class_name: 'Keyword::DeliveryMethodTranslation'
  end

  with_options foreign_key: :toimitustapa, primary_key: :selite do |o|
    o.has_many :customers,          class_name: 'Customer'
    o.has_many :freight_contracts
    o.has_many :freights
    o.has_many :manufacture_orders, class_name: 'ManufactureOrder::Order'
    o.has_many :offer_orders,       class_name: 'OfferOrder::Order'
    o.has_many :preorders,          class_name: 'Preorder::Order'
    o.has_many :project_orders,     class_name: 'ProjectOrder::Order'
    o.has_many :reclamation_orders, class_name: 'ReclamationOrder::Order'
    o.has_many :sales_order_drafts, class_name: 'SalesOrder::Draft'
    o.has_many :sales_orders,       class_name: 'SalesOrder::Order'
    o.has_many :stock_transfers,    class_name: 'StockTransfer::Order'
    o.has_many :waybills
    o.has_many :work_orders,        class_name: 'WorkOrder::Order'
  end

  has_many :customer_keywords, foreign_key: :avainsana, primary_key: :selite
  has_many :departures, foreign_key: :liitostunnus, class_name: 'DeliveryMethod::Departure'

  has_and_belongs_to_many :locations, join_table: :toimitustavat_toimipaikat, association_foreign_key: :toimipaikka_tunnus, foreign_key: :toimitustapa_tunnus

  validates :aktiivinen_kuljetus_kansallisuus, :maa_maara, :sisamaan_kuljetus_kansallisuus, inclusion: { in: Country.pluck(:koodi) }, allow_blank: true
  validates :jarjestys, numericality: { only_integer: true }, allow_blank: true
  validates :lahdon_selite, :sallitut_alustat, length: { maximum: 150 }
  validates :rahti_tuotenumero, :rahtikirjakopio_email, :kuljetusvakuutus_tuotenumero, :toim_nimi, :toim_nimitark, length: { maximum: 60 }
  validates :selite, uniqueness: true, presence: true, length: { maximum: 150 }
  validates :sisamaan_kuljetus, :aktiivinen_kuljetus, length: { maximum: 30 }
  validates :sopimusnro, :sallitut_maat, length: { maximum: 50 }
  validates :toim_osoite, length: { maximum: 55 }
  validates :toim_ovttunnus, length: { maximum: 25 }
  validates :toim_postino, length: { maximum: 15 }
  validates :toim_postitp, :toim_maa, length: { maximum: 35 }

  validate :adr_handling
  validate :alternative_adr_delivery_method
  validate :cargo_insurance_sku
  validate :freight_sku
  validate :unifaun_parameters

  before_save :defaults
  before_destroy :check_relations

  after_save :update_relations

  float_columns :jvkulu, :erilliskasiteltavakulu, :kuljetusvakuutus, :kuluprosentti, :ulkomaanlisa,
                :lisakulu, :lisakulu_summa

  accepts_nested_attributes_for :departures, allow_destroy: true
  accepts_nested_attributes_for :translations, allow_destroy: true

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

  enum rahtikirja: {
    generic_a4: 'rahtikirja_pdf.inc',
    itella_a5: 'rahtikirja_postitarra_pdf.inc',
    itella_priority_foreign: 'rahtikirja_postitarra_ulkomaa_pdf.inc',
    itella_thermal: 'rahtikirja_postitarra.inc',
    unifaun_online: 'rahtikirja_unifaun_uo_siirto.inc',
    unifaun_print_server: 'rahtikirja_unifaun_ps_siirto.inc',
    dpd_waybill: 'rahtikirja_dpd.inc',
    dpd_ftp: 'rahtikirja_dpd_siirto.inc',
    ups_ftp: 'rahtikirja_ups_siirto.inc',
    no_waybill: 'rahtikirja_tyhja.inc',
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

  def translated_locales
    translations.map(&:kieli)
  end

  def name_translated(locale)
    translations.find_by(kieli: locale).try(:selitetark) || selite
  end

  private

    def freight_sku
      return unless rahti_tuotenumero.present?

      cnt = company.products.no_inventory_management.where(tuoteno: rahti_tuotenumero).count
      errors.add :rahti_tuotenumero, I18n.t('errors.delivery_method.product_not_in_inventory_management') if cnt.zero?
    end

    def cargo_insurance_sku
      return unless kuljetusvakuutus_tuotenumero.present?

      cnt = company.products.no_inventory_management.where(tuoteno: kuljetusvakuutus_tuotenumero).count
      errors.add :kuljetusvakuutus_tuotenumero, I18n.t('errors.delivery_method.product_not_in_inventory_management') if cnt.zero?
    end

    def update_relations
      msg = []

      if selite_was.present? && selite_changed?
        update_list = [
          { count: company.delivery_methods.where(vak_kielto: selite_was).update_all(vak_kielto: selite), msg: 'delivery_methods' },
          { count: company.delivery_methods.where(vaihtoehtoinen_vak_toimitustapa: selite_was).update_all(vaihtoehtoinen_vak_toimitustapa: selite), msg: 'alternative_adr_delivery_methods' },
          { count: company.customers.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'customers' },
          { count: company.customer_keywords.where(avainsana: selite_was).update_all(avainsana: selite), msg: 'customer_keywords' },
          { count: company.sales_orders.not_delivered.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'not_delivered_sales_orders' },
          { count: company.sales_order_drafts.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'sales_order_drafts' },
          { count: company.stock_transfers.not_delivered.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'not_delivered_stock_transfers' },
          { count: company.preorders.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'preorders' },
          { count: company.offer_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'offer_orders' },
          { count: company.manufacture_orders.not_manufactured.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'not_manufactured_manufacture_orders' },
          { count: company.work_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'work_orders' },
          { count: company.project_orders.active.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'project_orders' },
          { count: company.reclamation_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'reclamation_orders' },
          { count: company.freights.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'freights' },
          { count: company.freight_contracts.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'freight_contracts' },
          { count: company.waybills.not_printed.where(toimitustapa: selite_was).update_all(toimitustapa: selite), msg: 'not_printed_waybills' },
        ]

        update_list.each do |update|
          count = update[:count]
          error = I18n.t "administration.delivery_methods.update.#{update[:msg]}", count: count
          msg << error unless count.zero?
        end
      end

      self.flash_notice = msg.to_sentence
    end

    def unifaun_parameters
      # Koontierätulostus ei toimi Unifaunin kanssa ilman "uusia pakkaustietoja"
      return unless unifaun_online? || unifaun_print_server?

      if !package_info_entry_allowed? && collective_batch?
        errors.add :base, I18n.t("errors.delivery_method.unifaun_info_missing")
      end
    end

    def adr_handling
      allowed = company.delivery_methods.permit_adr.shipment.pluck(:selite) + [ '', 'K' ]

      unless allowed.include? vak_kielto
        errors.add :vak_kielto, I18n.t('errors.messages.inclusion')
      end

      if vak_kielto_changed? && vak_kielto == 'K'
        count = company.delivery_methods.where(vaihtoehtoinen_vak_toimitustapa: selite).count

        if count > 0
          errors.add :vak_kielto, I18n.t('errors.delivery_method.in_use_adr')
        end
      end
    end

    def alternative_adr_delivery_method
      allowed = company.delivery_methods.permit_adr.shipment.pluck(:selite) + [ '' ]

      unless allowed.include? vaihtoehtoinen_vak_toimitustapa
        errors.add :vaihtoehtoinen_vak_toimitustapa, I18n.t('errors.messages.inclusion')
      end
    end

    def check_relations
      checklist = [
        { count: customers.count, error: "in_use_customers" },
        { count: sales_orders.not_delivered.count, error: "in_use_sales_orders" },
        { count: sales_order_drafts.count, error: "in_use_sales_order_drafts" },
        { count: freights.count, error: "in_use_freights" },
        { count: freight_contracts.count, error: "in_use_freight_contracts" },
        { count: customer_keywords.count, error: "in_use_customer_keywords" },
        { count: stock_transfers.not_delivered.count, error: "in_use_stock_transfers" },
        { count: preorders.count, error: "in_use_preorders" },
        { count: offer_orders.count, error: "in_use_offer_orders" },
        { count: manufacture_orders.count, error: "in_use_manufacture_orders" },
        { count: work_orders.count, error: "in_use_work_orders" },
        { count: project_orders.count, error: "in_use_project_orders" },
        { count: reclamation_orders.count, error: "in_use_reclamation_orders" },
        { count: waybills.not_printed.count, error: "in_use_waybills" },
        { count: company.delivery_methods.where(vak_kielto: selite).count, error: "in_use_delivery_method" },
        { count: company.delivery_methods.where(vaihtoehtoinen_vak_toimitustapa: selite).count, error: "in_use_delivery_method" },
      ]

      checklist.each do |check|
        count = check[:count]
        error = I18n.t "errors.delivery_method.#{check[:error]}", count: count

        errors.add(:base, error) unless count.zero?
      end

      checklist.all? { |check| check[:count].zero? }
    end

    def defaults
      self.kauppatapahtuman_luonne ||= 0
      self.kuljetusmuoto ||= 0
      self.sisamaan_kuljetusmuoto ||= 0
    end
end
