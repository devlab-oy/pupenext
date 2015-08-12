module PrinterHelper
  ROOT = 'administration.printers'

  def merkisto_options
    Printer.merkistos.map do |key,_|
      [ t("#{ROOT}.merkisto_options.#{key}"), key ]
    end
  end

  def mediatyyppi_options
    Printer.mediatyyppis.map do |key,_|
      [ t("#{ROOT}.mediatyyppi_options.#{key}"), key ]
    end
  end
end
