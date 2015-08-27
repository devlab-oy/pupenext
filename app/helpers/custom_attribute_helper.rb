module CustomAttributeHelper
  def custom_attribute_set_options
    Keyword::CustomAttribute.where.not(set_name: '').map do |a|
      [ "#{a.table.capitalize} - #{a.set_name}", "#{a.table}/#{a.set_name}" ]
    end.uniq.sort
  end

  def custom_attributes_tables_options
    # List of table names available for custom attributes
    [
      [ Customer.model_name.human, 'asiakas' ],
      [ 'Tuote', 'tuote' ],
      [ 'Toimittaja', 'toimi' ],
    ]
  end

  def attributes_for_table(table)
    columns = ActiveRecord::Base.connection.columns table.to_s
    columns.map &:name
  end
end
