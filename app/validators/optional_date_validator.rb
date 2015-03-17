class OptionalDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    date = record.read_attribute_before_type_cast(attribute.to_s)
    return if date.nil?

    begin
      DateTime.parse(value.to_s)
    rescue
      record.errors[attribute] << (options[:message] || "is not a valid date")
    end
  end
end
