module Administration::PrintersHelper
  def merkisto_types
    Printer.merkisto_types.map { |type| [I18n.t("options.merkisto_types.#{type}"), type] }
  end

  def mediatyyppi_types
    Printer.mediatyyppi_types.map { |type| [I18n.t("options.mediatyyppi_types.#{type}"), type] }
  end
end
