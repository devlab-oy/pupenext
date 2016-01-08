module CustomAttributeHelper
  def custom_attribute_set_options
    Keyword::CustomAttribute.all.map do |a|
      [ "#{a.table.try(:capitalize)} - #{a.set_name}", "#{a.table}+#{a.set_name}" ]
    end.uniq.sort
  end

  def database_field_options(table_alias_set: nil)
    options = []
    skip_columns = %w(yhtio tunnus)

    if table_alias_set.present?
      only_table, set_name = table_alias_set.split('+')

      added = Keyword::CustomAttribute.where(set_name: set_name).pluck(:database_field)
      skip_columns += added.map { |f| f.split('.').last }
    end

    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.columns(table).each do |column|
        name = column.name
        next if only_table && only_table != table

        options << "#{table}.#{name}" unless skip_columns.include?(name)
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
