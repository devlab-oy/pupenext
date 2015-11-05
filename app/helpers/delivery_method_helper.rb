module DeliveryMethodHelper
  ROOT = 'administration.delivery_methods'

  def adr_prohibition_options
    options = [
      [ t("administration.delivery_methods.adr_prohibition_options.permit_adr"), "" ],
      [ t("administration.delivery_methods.adr_prohibition_options.adr_prohibition"), "K" ]
    ]

    text = t("administration.delivery_methods.adr_prohibition_options.adr_shipment")

    options = options + adr_options(text)
    options.reject { |i,_| i.empty? }
  end

  def alternative_adr_delivery_method_options
    options = [
      [ t("administration.delivery_methods.alternative_adr_delivery_method_options.adr_products_transfer_prohibition"), "" ],
    ]

    text = t("administration.delivery_methods.alternative_adr_delivery_method_options.adr_products_transfer_permit")

    options = options + adr_options(text)
    options.reject { |i,_| i.empty? }
  end

  def adr_options(text)
    DeliveryMethod.permit_adr.shipment.map do |i|
      [ "#{text} #{i.selite}", i.selite ]
    end
  end

  def label_options
    options = DeliveryMethod.osoitelappus.map do |key,_|
      [ t("#{ROOT}.label_options.#{key}"), key ]
    end

    options.reject { |_,key| !Current.company.parameter.collection_batch_based_on_dimensions? && key == 'simple_label' }
  end

  def pickup_options
    DeliveryMethod.noutos.map do |key,_|
      [ t("#{ROOT}.pickup_options.#{key}"), key ]
    end
  end

  def saturday_delivery_options
    DeliveryMethod.lauantais.map do |key,_|
      [ t("#{ROOT}.saturday_delivery_options.#{key}"), key ]
    end
  end

  def transport_unit_options
    DeliveryMethod.kuljyksikkos.map do |key,_|
      [ t("#{ROOT}.transport_unit_options.#{key}"), key ]
    end
  end

  def print_method_options
    DeliveryMethod.tulostustapas.map do |key,_|
      [ t("#{ROOT}.print_method_options.#{key}"), key ]
    end
  end

  def freight_contract_options
    DeliveryMethod.merahtis.map do |key,_|
      [ t("#{ROOT}.freight_contract_options.#{key}"), key ]
    end
  end

  def logy_waybill_number_options
    DeliveryMethod.logy_rahtikirjanumerots.map do |key,_|
      [ t("#{ROOT}.logy_waybill_number_options.#{key}"), key ]
    end
  end

  def extranet_options
    DeliveryMethod.extranets.map do |key,_|
      [ t("#{ROOT}.extranet_options.#{key}"), key ]
    end
  end

  def container_options
    DeliveryMethod.konttis.map do |key,_|
      [ t("#{ROOT}.container_options.#{key}"), key ]
    end
  end

  def cash_on_delivery_prohibition_options
    DeliveryMethod.jvkieltos.map do |key,_|
      [ t("#{ROOT}.cash_on_delivery_prohibition_options.#{key}"), key ]
    end
  end

  def special_packaging_prohibition_options
    DeliveryMethod.erikoispakkaus_kieltos.map do |key,_|
      [ t("#{ROOT}.special_packaging_prohibition_options.#{key}"), key ]
    end
  end

  def packing_line_prohibition_options
    DeliveryMethod.ei_pakkaamoas.map do |key,_|
      [ t("#{ROOT}.packing_line_prohibition_options.#{key}"), key ]
    end
  end

  def waybill_specification_options
    DeliveryMethod.erittelies.map do |key,_|
      [ t("#{ROOT}.waybill_specification_options.#{key}"), key ]
    end
  end

  def new_packaging_information_options
    DeliveryMethod.uudet_pakkaustiedots.map do |key,_|
      [ t("#{ROOT}.new_packaging_information_options.#{key}"), key ]
    end
  end

  def transportation_insurance_type_options
    DeliveryMethod.kuljetusvakuutus_tyyppis.map do |key,_|
      [ t("#{ROOT}.transportation_insurance_type_options.#{key}"), key ]
    end
  end

  def waybill_options
    [
      [ t('administration.delivery_methods.waybill_options.generic_a4'),              :generic_a4 ],
      [ t('administration.delivery_methods.waybill_options.itella_a5'),               :itella_a5 ],
      [ t('administration.delivery_methods.waybill_options.itella_thermal'),          :itella_thermal ],
      [ t('administration.delivery_methods.waybill_options.itella_priority_foreign'), :itella_priority_foreign ],
      [ t('administration.delivery_methods.waybill_options.unifaun_online'),          :unifaun_online ],
      [ t('administration.delivery_methods.waybill_options.unifaun_print_server'),    :unifaun_print_server ],
      [ t('administration.delivery_methods.waybill_options.dpd_waybill'),             :dpd_waybill ],
      [ t('administration.delivery_methods.waybill_options.dpd_ftp'),                 :dpd_ftp ],
      [ t('administration.delivery_methods.waybill_options.ups_ftp'),                 :ups_ftp ],
      [ t('administration.delivery_methods.waybill_options.no_waybill'),              :no_waybill ],
    ]
  end
end
