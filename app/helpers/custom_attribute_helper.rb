module CustomAttributeHelper
  def custom_attribute_set_options
    Keyword::CustomAttribute.all.map do |a|
      [ "#{a.table.capitalize} - #{a.set_name}", "#{a.table}_#{a.set_name}" ]
    end.uniq.sort
  end

  def database_field_options
    options = []

    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.columns(table).each do |column|
        name = column.name
        skip_columns = %w(yhtio tunnus)

        options << "#{table}.#{name}" unless skip_columns.include? name
      end
    end

    options
  end

  def attribute_visibility_options
    [
      [ t('administration.custom_attributes.visibility_options.visible'), 'visible' ],
      [ t('administration.custom_attributes.visibility_options.hidden'),  'hidden'  ],
    ]
  end

  def attribute_required_options
    [
      [ t('administration.custom_attributes.required_options.optional'),  'optional'  ],
      [ t('administration.custom_attributes.required_options.mandatory'), 'mandatory' ],
    ]
  end
end
