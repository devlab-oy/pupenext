module LocationHelper
  def toimipaikka_options
    Location.all.map do |l|
      [ l.nimi, l.tunnus ]
    end
  end
end
