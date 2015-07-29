module PupenextDateField
  def pupenext_date_field(method, options = {})
    fields = default_values method

    inputs = []
    fields.each do |key, option|
      # @object.send(method).send(key) calls .day .month and .year on date
      option[:html_options][:value] = @object.send(method).send(key) if @object.send(method).is_a?(Date)
      inputs << @template.number_field_tag(option[:name], method, option[:html_options].merge(options))
    end

    inputs.join.html_safe
  end

  private

    def pupenext_date_field_name(field_name, type)
      prefix     = @object_name.to_s
      field_name += "(#{ActionView::Helpers::DateTimeSelector::POSITION[type]}i)"

      "#{prefix}[#{field_name}]"
    end

    def default_values(method)
      {
        day: {
          name: pupenext_date_field_name(method.try(:to_s), :day),
          html_options: {
            value: '',
            size:  3,
            min:   1,
            max:   31
          },
        },
        month: {
          name: pupenext_date_field_name(method.try(:to_s), :month),
          html_options: {
            value: '',
            size:  3,
            min:   1,
            max:   12
          },
        },
        year: {
          name: pupenext_date_field_name(method.try(:to_s), :year),
          html_options: {
            value: '',
            size:  5,
            min:   1,
            max:   9999
          },
        },
      }
    end
end
