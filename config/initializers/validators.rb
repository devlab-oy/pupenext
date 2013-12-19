module Validators

  def valid_date(key, date)
    if date.nil?
      errors.add(key, "is invalid date")
      return false
    end

    begin
      DateTime.parse(date.to_s)
      true
    rescue
      errors.add(key, "is invalid date")
      false
    end
  end

end
