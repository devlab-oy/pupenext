class HuutokauppaMail
  attr_reader :mail

  def initialize(raw_source)
    @mail = Mail.new(raw_source)
  end
end
