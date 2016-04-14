class HuutokauppaMail
  attr_reader :mail

  def initialize(raw_source)
    @mail = Mail.new(raw_source)
  end

  def type
    case @mail.subject
    when /Tarjous automaattisesti hyväksytty/
      :offer_automatically_accepted
    when /Toimituksen tarjouspyyntö/
      :delivery_offer_request
    when /Toimitus tilattu/
      :delivery_ordered
    end
  end
end
