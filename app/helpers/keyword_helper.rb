module KeywordHelper
  def oletus_alv_options
    vat = Keyword::Vat.all.map do |k|
      [
        number_to_percentage(k.selite, strip_insignificant_zeros: true),
        k.selite
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

  def waybill_options
    Keyword::Waybill.pluck(:selitetark, :selite)
  end

  def mode_of_transport_options
    Keyword::ModeOfTransport.pluck(:selitetark, :selite)
  end

  def nature_of_transaction_options
    Keyword::NatureOfTransaction.pluck(:selitetark, :selite)
  end

  def customs_options
    Keyword::Customs.pluck("CONCAT(selite, ' ', selitetark)", :selite)
  end

  def sorting_point_options
    Keyword::SortingPoint.pluck(:selitetark, :selite)
  end
end
