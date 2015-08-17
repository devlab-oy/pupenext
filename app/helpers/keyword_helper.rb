module KeywordHelper
  def oletus_alv_options
    Keyword::Vat.all.map do |k|
      [
        number_to_percentage(k.selite, strip_insignificant_zeros: true),
        k.selite
      ]
    end
  end
end
