class PupenextFormBuilder < ActionView::Helpers::FormBuilder
  def pupenext_date_field(method)
    if @object.send(method).is_a?(Date)
      day   = @object.send(method).day
      month = @object.send(method).month
      year  = @object.send(method).year
    else
      day   = ''
      month = ''
      year  = ''
    end

    @template.text_field_tag(@object_name, method, { value: day, size: 3 }) + ' ' +
      @template.text_field_tag(@object_name, method, { value: month, size: 3 }) + ' ' +
      @template.text_field_tag(@object_name, method, { value: year, size: 5 })
  end
end
