# FormBuilder that allows only fields spcified in custom_attributes
class AdminFormBuilder < SimpleForm::FormBuilder
  def initialize(*) #:nodoc:
    super
    @default_set = Keyword::CustomAttribute::DEFAULT_SET_NAME
    @alias_set = options[:alias_set] || @default_set
    @table_name = @object.class.table_name
  end

  def input(attribute_name, options = {}, &block)
    return unless input_allowed? attribute_name

    # If we're creating a new record, and the attribute is blank.
    # Check for default value in custom_attributes
    if @object.new_record? && @object.send(attribute_name).blank?
      default = { input_html: { value: default_value(attribute_name) }}
      options = default.deep_merge(options)
    end

    super(attribute_name, options, &block)
  end

  private

    def input_allowed?(attribute_name)
      # If have no custom_attributes defined, and we're using default set -> allow everything
      return true if custom_attributes.blank? && @alias_set == @default_set

      # Check that current attribute is marked as visible
      custom_attribute(attribute_name).try(:visible?)
    end

    def default_value(attribute_name)
      custom_attribute(attribute_name).try(:default_value)
    end

    def custom_attribute(attribute_name)
      # Check that current attribute is marked as visible
      database_field = "#{@table_name}.#{attribute_name}"

      custom_attributes.find_by(database_field: database_field)
    end

    def custom_attributes
      Keyword::CustomAttribute.fetch_set table_name: @table_name, set_name: @alias_set
    end
end
