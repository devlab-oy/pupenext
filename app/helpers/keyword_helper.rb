module KeywordHelper
  def oletus_alv_options
    vat = Keyword::Vat.all.map do |k|
      [
        number_to_percentage(k.selite, strip_insignificant_zeros: true),
        k.selite.to_f.to_s
      ]
    end

    Keyword::ForeignVat.where(selitetark_2: Location.countries).map do |k|
      vat << [
        number_to_percentage(k.selite, strip_insignificant_zeros: true),
        k.selite
      ]
    end

    vat.uniq.sort
  end

  def translatable_locales_options
    [
      [ 'Eesti',    'ee' ],
      [ 'Englanti', 'en' ],
      [ 'Norja',    'no' ],
      [ 'Ruotsi',   'se' ],
      [ 'Saksa',    'de' ],
      [ 'Tanska',   'dk' ],
      [ 'Venäjä',   'ru' ],
    ]
  end
end
