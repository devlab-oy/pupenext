module Validators

  def valid_date(key, model)
    date_raw = model.read_attribute_before_type_cast(key.to_s).to_s
    return true if date_raw.empty?

    begin
      DateTime.parse(date_raw)
      true
    rescue
      errors.add(key, "is invalid date")
      false
    end
  end

end
