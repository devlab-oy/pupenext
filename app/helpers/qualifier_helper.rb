module QualifierHelper
  ROOT = 'administration.qualifiers'

  def kaytossa_options
    Qualifier.kaytossas.map do |key,_|
      [ t("#{ROOT}.kaytossa_options.#{key}"), key ]
    end
  end

  def qualifier_tyyppi_options
    Qualifier.child_class_names.map do |v, m|
      [ m.model_name.human, v ]
    end
  end

  def isa_tarkenne_options
    Qualifier.in_use.code_name_order.map do |q|
      [ q.nimitys, q.tunnus ]
    end
  end
end
