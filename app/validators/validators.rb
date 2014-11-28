module Validators

  def valid_date?(value)
    return true if value.nil?
    begin
      DateTime.parse(value.to_s)
    rescue
      false
    end
  end

end
