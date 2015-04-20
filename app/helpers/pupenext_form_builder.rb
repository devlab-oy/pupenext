class PupenextFormBuilder < ActionView::Helpers::FormBuilder
  def pupenext_date_field(method)
    options = default_values method

    options.map! { |option| option[:value] = '' } unless @object.send(method).is_a?(Date)

    @template.text_field_tag(options[:day][:name], method, { value: options[:day][:value], size: options[:day][:size] }) + ' ' +
      @template.text_field_tag(options[:month][:name], method, { value: options[:month][:value], size: options[:month][:size] }) + ' ' +
      @template.text_field_tag(options[:year][:name], method, { value: options[:year][:value], size: options[:year][:size] })
  end

  def input_name_from_type(field_name, type)
    prefix     = @object_name.to_s
    field_name += "(#{ActionView::Helpers::DateTimeSelector::POSITION[type]}i)"

    "#{prefix}[#{field_name}]"
  end

  def default_values(method)
    {
      day:   {
        value: @object.send(method).day,
        name:  input_name_from_type(method.try(:to_s), :day),
        size:  3
      },
      month: {
        value: @object.send(method).month,
        name:  input_name_from_type(method.try(:to_s), :month),
        size:  3
      },
      year:  {
        value: @object.send(method).year,
        name:  input_name_from_type(method.try(:to_s), :year),
        size:  5
      },
    }
  end
end
