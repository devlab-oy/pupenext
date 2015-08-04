module PrinterHelper
  ROOT = 'administration.printers'

  def merkisto_options
    Printer.merkistos.map do |key, value|
      [ t("#{ROOT}.merkisto_options.#{key}"), value ]
    end
  end

  def mediatyyppi_options
    Printer.mediatyyppis.map do |key, value|
      [ t("#{ROOT}.mediatyyppi_options.#{key}"), value ]
    end
  end
end
