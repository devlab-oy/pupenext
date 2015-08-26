module CustomAttributeHelper
  def custom_attribute_set_options
    Keyword::CustomAttribute.select(:set_name)
      .distinct.order(:set_name).map(&:set_name).reject(&:empty?)
  end

  def attributes_for_table(table)
    columns = ActiveRecord::Base.connection.columns table.to_s
    columns.map &:name
  end
end
