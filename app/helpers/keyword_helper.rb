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
end
