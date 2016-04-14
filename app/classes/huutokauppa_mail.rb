class HuutokauppaMail
  attr_reader :mail

  def initialize(raw_source)
    @mail = Mail.new(raw_source)
  end

  def type
    case @mail.subject
    when /Tarjous automaattisesti hyväksytty/
      :offer_automatically_accepted
    end
  end
end
