module QualifierHelper
  ROOT = 'administration.qualifiers'

  def kaytossa_options
    Qualifier.kaytossas.map do |key,_|
      [ t("#{ROOT}.kaytossa_options.#{key}"), key ]
    end
  end

  def type_options
    Qualifier.qualifiers.map do |v, m|
      [ m.human_readable_type, v ]
    end
  end
end
