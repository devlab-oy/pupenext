module CustomAttributeHelper
  def custom_attribute_set_options
    Keyword::CustomAttribute.select(:set_name)
      .distinct.order(:set_name).map(&:set_name).reject(&:empty?)
  end
end
