module PackingAreaHelper
  def varasto_options
    Warehouse.all.map do |w|
      [ w.nimitys, w.tunnus ]
    end
  end

  def printteri_options
    Printer.all.map do |p|
      [ p.kirjoitin, p.tunnus ]
    end
  end
end
