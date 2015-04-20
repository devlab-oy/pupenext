class PupenextFormBuilder < ActionView::Helpers::FormBuilder
  def pupenext_date_field(method)
    options = default_values method

    inputs = []
    options.each do |key, option|
      # This calls .day .month and .year on date
      option[:value] = @object.send(method).send(key) if @object.send(method).is_a?(Date)
      inputs << @template.text_field_tag(option[:name], method, { value: option[:value], size: option[:size] })
    end

    inputs.join(' ').html_safe
  end

  private

    def pupenext_date_field_name(field_name, type)
      prefix     = @object_name.to_s
      field_name += "(#{ActionView::Helpers::DateTimeSelector::POSITION[type]}i)"

      "#{prefix}[#{field_name}]"
    end

    def default_values(method)
      {
        day:   {
          value: '',
          name:  pupenext_date_field_name(method.try(:to_s), :day),
          size:  3
        },
        month: {
          value: '',
          name:  pupenext_date_field_name(method.try(:to_s), :month),
          size:  3
        },
        year:  {
          value: '',
          name:  pupenext_date_field_name(method.try(:to_s), :year),
          size:  5
        },
      }
    end
end
