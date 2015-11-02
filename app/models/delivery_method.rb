class DeliveryMethod < BaseModel
  include AttributeSanitator
  include Searchable

  with_options foreign_key: :selite do |o|
    o.has_many :mode_of_transports,     primary_key: :kuljetusmuoto,              class_name: 'Keyword::ModeOfTransport'
    o.has_many :nature_of_transactions, primary_key: :kauppatapahtuman_luonne,    class_name: 'Keyword::NatureOfTransaction'
    o.has_many :customs,                primary_key: :poistumistoimipaikka_koodi, class_name: 'Keyword::Customs'
    o.has_many :sorting_point,          primary_key: :lajittelupiste,             class_name: 'Keyword::SortingPoint'
    o.has_many :customer_keywords,      primary_key: :avainsana
    o.has_many :waybills,               primary_key: :toimitustapa
  end

  has_many :translations, foreign_key: :selite, class_name: 'Keyword::DeliveryMethodTranslation'

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

  validate :vaihtoehtoinen_vak_toimitustapa_validation
  validate :vak_kielto_validation
  validate :mandatory_new_packaging_information if :package_info_entry_denied && :collective_batch
  validate :freight_sku, if: :has_freight_sku?
  validate :cargo_insurance_sku, if: :has_cargo_insurance_sku?

  before_save :defaults
  before_destroy :check_relations

  after_save :update_relations

  float_columns :jvkulu, :erilliskasiteltavakulu, :kuljetusvakuutus, :kuluprosentti, :ulkomaanlisa,
                :lisakulu, :lisakulu_summa

  accepts_nested_attributes_for :translations, allow_destroy: true

  scope :permit_adr, -> { where(vak_kielto: '') }

  attr_accessor :flash_notice

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

    def has_freight_sku?
      rahti_tuotenumero.present?
    end

    def freight_sku
      cnt = company.products.no_inventory_management.where(tuoteno: rahti_tuotenumero).count
      errors.add :rahti_tuotenumero, I18n.t('errors.delivery_method.product_not_in_inventory_management') if cnt.zero?
    end

    def has_cargo_insurance_sku?
      kuljetusvakuutus_tuotenumero.present?
    end

    def cargo_insurance_sku
      cnt = company.products.no_inventory_management.where(tuoteno: kuljetusvakuutus_tuotenumero).count
      errors.add :kuljetusvakuutus_tuotenumero, I18n.t('errors.delivery_method.product_not_in_inventory_management') if cnt.zero?
    end

    def update_relations
      msg = []

      if selite_was.present?
        cnt = company.delivery_methods.where(vak_kielto: selite_was).update_all(vak_kielto: selite)
        msg << I18n.t('administration.delivery_methods.update.delivery_methods', count: cnt) if cnt.nonzero?

        cnt = company.delivery_methods.where(vaihtoehtoinen_vak_toimitustapa: selite_was).update_all(vaihtoehtoinen_vak_toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.alternative_adr_delivery_methods', count: cnt) if cnt.nonzero?

        cnt = company.customers.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.customers', count: cnt) if cnt.nonzero?

        cnt = company.sales_orders.not_delivered.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.not_delivered_sales_orders', count: cnt) if cnt.nonzero?

        cnt = company.sales_order_drafts.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.sales_order_drafts', count: cnt) if cnt.nonzero?

        cnt = company.customer_keywords.where(avainsana: selite_was).update_all(avainsana: selite)
        msg << I18n.t('administration.delivery_methods.update.customer_keywords', count: cnt) if cnt.nonzero?

        cnt = company.stock_transfers.not_delivered.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.not_delivered_stock_transfers', count: cnt) if cnt.nonzero?

        cnt = company.preorders.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.preorders', count: cnt) if cnt.nonzero?

        cnt = company.offer_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.offer_orders', count: cnt) if cnt.nonzero?

        cnt = company.manufacture_orders.not_manufactured.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.not_manufactured_manufacture_orders', count: cnt) if cnt.nonzero?

        cnt = company.work_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.work_orders', count: cnt) if cnt.nonzero?

        cnt = company.project_orders.active.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.project_orders', count: cnt) if cnt.nonzero?

        cnt = company.reclamation_orders.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.reclamation_orders', count: cnt) if cnt.nonzero?

        cnt = company.freights.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.freights', count: cnt) if cnt.nonzero?

        cnt = company.freight_contracts.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.freight_contracts', count: cnt) if cnt.nonzero?

        cnt = company.waybills.not_printed.where(toimitustapa: selite_was).update_all(toimitustapa: selite)
        msg << I18n.t('administration.delivery_methods.update.not_printed_waybills', count: cnt) if cnt.nonzero?
      end

      flash_notice = msg.join(', ')
    end

    def mandatory_new_packaging_information
      if unifaun_online? || unifaun_print_server?
        errors.add :base, I18n.t("errors.delivery_method.unifaun_info_missing")
      end
    end

    def vak_kielto_validation
      allowed = company.delivery_methods.permit_adr.shipment.pluck(:selite) + [ '', 'K' ]

      unless allowed.include? vak_kielto
        errors.add :vak_kielto, I18n.t('errors.messages.inclusion')
      end

      if vak_kielto_was.present? && vak_kielto.empty?
        count = company.delivery_methods.where(vaihtoehtoinen_vak_toimitustapa: selite).count

        if count > 0
          errors.add :vak_kielto, I18n.t('errors.delivery_method.in_use_adr')
        end
      end
    end

    def vaihtoehtoinen_vak_toimitustapa_validation
      allowed = company.delivery_methods.permit_adr.shipment.pluck(:selite) + [ '' ]

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

      count = company.stock_transfers.not_delivered.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_stock_transfers", count: count)
        allow_delete = false
      end

      count = company.preorders.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_preorders", count: count)
        allow_delete = false
      end

      count = company.offer_orders.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_offer_orders", count: count)
        allow_delete = false
      end

      count = company.manufacture_orders.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_manufacture_orders", count: count)
        allow_delete = false
      end

      count = company.work_orders.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_work_orders", count: count)
        allow_delete = false
      end

      count = company.project_orders.active.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_project_orders", count: count)
        allow_delete = false
      end

      count = company.reclamation_orders.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_reclamation_orders", count: count)
        allow_delete = false
      end

      count = company.waybills.not_printed.where(toimitustapa: selite).count
      if count.nonzero?
        errors.add :base, I18n.t("errors.delivery_method.in_use_waybills", count: count)
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
