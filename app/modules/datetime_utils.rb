module DatetimeUtils
  def self.is_db_date?(value)
    is_db_format?(value) && is_valid?(value)
  end

  def self.is_db_format?(value)
    parts = value.split '-' if value.is_a?(String)

    return false if parts.nil?
    return false unless parts.count == 3

    begin
      parts.map! { |part| part.to_i }
      Date.new parts[0], parts[1], parts[2]
    rescue
      return false
    end

    true
  end

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
