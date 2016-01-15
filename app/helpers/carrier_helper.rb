module CarrierHelper
  ROOT = 'administration.carriers'

  def neutraali_options
    Carrier.neutraalis.map do |key,_|
      [ t("#{ROOT}.neutraali_options.#{key}"), key ]
    end
  end

  def carrier_options
    Carrier.order(:nimi, :koodi).pluck(:nimi, :koodi)
  end

  def rahdinkuljettaja_options
    Carrier.all.map do |c|
      [ c.nimi, c.koodi ]
    end
  end
end
