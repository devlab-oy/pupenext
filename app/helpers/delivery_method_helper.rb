module DeliveryMethodHelper
  ROOT = 'administration.delivery_methods'

  def waybill_options
    Keyword::Waybill.all.map { |i| [ i.selitetark, i.selite ] }
  end

  def mode_of_transport_options
    Keyword::ModeOfTransport.all.map { |i| [ i.selitetark, i.selite ] }
  end

  def nature_of_transaction_options
    Keyword::NatureOfTransaction.all.map { |i| [ i.selitetark, i.selite ] }
  end

  def customs_options
    Keyword::Customs.all.map { |i| [ "#{i.selite} #{i.selitetark}", i.selite ] }
  end

  def sorting_point_options
    Keyword::SortingPoint.all.map { |i| [ i.selitetark, i.selite ] }
  end

  def label_options
    options = DeliveryMethod.osoitelappus.map do |key,_|
      [ t("#{ROOT}.label_options.#{key}"), key ]
    end

    options.reject { |_,key| !Current.company.parameter.use_kerayserat? && key == 'simple_label' }
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
end
