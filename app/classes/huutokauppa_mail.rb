class HuutokauppaMail
  attr_reader :mail

  def initialize(raw_source)
    @mail = Mail.new(raw_source)
    @doc  = Nokogiri::HTML(@mail.body.to_s.force_encoding(Encoding::UTF_8))
  end

  def type
    case @mail.subject
    when /Tarjous automaattisesti hyväksytty/
      :offer_automatically_accepted
    when /Toimituksen tarjouspyyntö/
      :delivery_offer_request
    when /Toimitus tilattu/
      :delivery_ordered
    when /Nettihuutokauppa on päättynyt/
      :auction_ended
    when /Tarjous hyväksytty/
      :offer_accepted
    when /Tarjous hylätty/
      :offer_declined
    when /Kauppahinta maksettu/
      :purchase_price_paid
    when /Huutaja noutaa/
      :bidder_picks_up
    end
  end

  def customer_name
    customer_info[:name]
  end

  def customer_email
    customer_info[:email]
  end

  private

    def customer_info
      @customer_info ||= begin
        info  = {}
        regex = %r{
          Ostajan\syhteystiedot:\s*(?<name>.*$)\s*(?<email>.*$)\s*Puhelin:\s*(?<phone>.*$)\s*
          Osoite:\s*(?<address>.*$)\s*(?<postcode>\d*)\s*(?<city>.*$)\s*(?<country>.*$)
        }x

        @doc.content.match(regex) do |match|
          info = match.names.each_with_object({}) do |name, hash|
            hash[name.to_sym] = match[name]
          end
        end

        info
      end
    end
end
