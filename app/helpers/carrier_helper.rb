module CarrierHelper
  ROOT = 'administration.carriers'

  def neutraali_options
    Carrier.neutraalis.map do |key,_|
      [ t("#{ROOT}.neutraali_options.#{key}"), key ]
    end
  end

  def carrier_options
    Carrier.pluck(:nimi, :koodi)
  end
end
