module QualifierHelper
  ROOT = 'administration.qualifiers'

  def kaytossa_options
    Qualifier.kaytossas.map do |key,_|
      [ t("#{ROOT}.kaytossa_options.#{key}"), key ]
    end
  end
end
