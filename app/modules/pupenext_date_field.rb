module PupenextDateField
  def pupenext_date_field(fieldname, options = {})
    @fieldname = fieldname

    inputs = default_options.map do |option|
      html_options = option[:html_options].merge(options)

      @template.text_field_tag(option[:name], fieldname, html_options)
    end

    inputs.join.html_safe
  end

  private

    def default_options
      prefix = @object_name.to_s
      [
        {
          name: "#{prefix}[#{@fieldname}[day]]",
          html_options: {
            value: @object.send(@fieldname).try(:day),
            size: 3,
            pattern: "[0-9]*"
          },
        },
        {
          name: "#{prefix}[#{@fieldname}[month]]",
          html_options: {
            value: @object.send(@fieldname).try(:month),
            size: 3,
            pattern: "[0-9]*"
          },
        },
        {
          name: "#{prefix}[#{@fieldname}[year]]",
          html_options: {
            value: @object.send(@fieldname).try(:year),
            size: 5,
            pattern: "[0-9]*"
          },
        },
      ]
    end
end
