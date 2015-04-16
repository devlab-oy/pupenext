module DatetimeUtils
  def self.is_valid?(value)
    begin
      DateTime.parse(value.to_s)
    rescue
      return false
    end

    true
  end

  def self.parse(value)
    DateTime.parse(value.to_s)
  end
end
