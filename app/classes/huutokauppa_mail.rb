class HuutokauppaMail
  attr_reader :mail

  DELIVERY_PRODUCT_NUMBERS = (90..95).to_a + (90..95).to_a.map { |e| "#{e}MAX" }

  def initialize(raw_source)
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @mail = Mail.new(raw_source)
    @doc  = Nokogiri::HTML(@mail.body.to_s.force_encoding(Encoding::UTF_8))
  end

  def type
    case @mail.subject
    when /Nettihuutokauppa on päättynyt/
      :auction_ended
    when /Huutaja noutaa/
      :bidder_picks_up
    when /Toimituksen tarjouspyyntö/
      :delivery_offer_request
    when /Toimitus tilattu/
      :delivery_ordered
    when /Tarjous hyväksytty/
      :offer_accepted
    when /Tarjous automaattisesti hyväksytty/
      :offer_automatically_accepted
    when /Tarjous hylätty/
      :offer_declined
    when /Kauppahinta maksettu/
      :purchase_price_paid
    end
  end

  def customer_name
    customer_info[:name]
  end

  def customer_email
    customer_info[:email]
  end

  def customer_phone
    customer_info[:phone]
  end

  def customer_address
    customer_info[:address]
  end

  def customer_postcode
    customer_info[:postcode]
  end

  def customer_city
    customer_info[:city]
  end

  def customer_country
    customer_info[:country]
  end

  def delivery_name
    delivery_info[:name]
  end

  def delivery_address
    delivery_info[:address]
  end

  def delivery_postcode
    delivery_info[:postcode]
  end

  def delivery_city
    delivery_info[:city]
  end

  def delivery_phone
    delivery_info[:phone]
  end

  def delivery_email
    delivery_info[:email]
  end

  def delivery_price_without_vat
    return unless delivery_price_with_vat

    delivery_price_with_vat - delivery_vat_amount
  end

  def delivery_price_with_vat
    return unless auction_info[:delivery_price_with_vat]

    auction_info[:delivery_price_with_vat].sub(',', '.').to_d
  end

  def delivery_vat_percent
    return unless auction_info[:delivery_vat_percent]

    auction_info[:delivery_vat_percent].sub(',', '.').to_d
  end

  def delivery_vat_amount
    return unless auction_info[:delivery_vat_amount]

    auction_info[:delivery_vat_amount].sub(',', '.').to_d
  end

  def total_price_with_vat
    return auction_price_with_vat unless auction_info[:total_price_with_vat]

    auction_info[:total_price_with_vat].sub(',', '.').to_d
  end

  def auction_id
    subject_info[:auction_id]
  end

  def auction_title
    auction_info[:auction_title]
  end

  def auction_closing_date
    Time.parse(auction_info[:closing_date])
  end

  def auction_price_without_vat
    auction_info[:winning_bid].sub(',', '.').to_d
  end

  def auction_price_with_vat
    auction_info[:price].sub(',', '.').to_d
  end

  def auction_vat_percent
    auction_info[:vat].sub(',', '.').to_d
  end

  def auction_vat_amount
    auction_info[:vat_amount].sub(',', '.').to_d
  end

  def find_customer
    @customer ||= Customer.find_by(email: customer_email) if customer_email
  end

  def create_customer
    return unless customer_name

    Customer.create!(
      email: customer_email,
      gsm: customer_phone,
      kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
      nimi: customer_name,
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
      ytunnus: auction_id,
    )
  end

  def update_customer
    return unless find_customer

    find_customer.update!(
      gsm: customer_phone,
      nimi: customer_name,
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
    )
  end

  def update_or_create_customer
    if find_customer
      update_customer

      return find_customer
    end

    create_customer
  end

  def find_draft
    @draft ||= SalesOrder::Draft.find_by!(viesti: auction_id)
  end

  def find_order
    @order ||= SalesOrder::Order.find_by!(viesti: auction_id)
  end

  def update_order_customer_info
    return unless customer_name

    find_draft.update!(
      email: customer_email,
      nimi: customer_name,
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
      puh: customer_phone,
    )
  end

  def update_order_delivery_info
    return unless delivery_name

    find_order.update!(
      toim_email: delivery_email,
      toim_nimi: delivery_name,
      toim_osoite: delivery_address,
      toim_postino: delivery_postcode,
      toim_postitp: delivery_city,
      toim_puh: delivery_phone,
    )
  end

  def update_order_product_info
    find_draft.rows.first.update!(
      alv: auction_vat_percent,
      hinta: auction_price_without_vat,
      hinta_alkuperainen: auction_price_without_vat,
      hinta_valuutassa: auction_price_without_vat,
      nimitys: auction_title,
      rivihinta: auction_price_without_vat,
      rivihinta_valuutassa: auction_price_without_vat,
    )
  end

  def create_sales_order
    return unless customer_name

    customer_id = find_customer.try(:id) || create_customer.id

    response = LegacyMethods.pupesoft_function(:luo_myyntitilausotsikko, customer_id: customer_id)
    sales_order_id = response[:sales_order_id]

    SalesOrder::Draft.find(sales_order_id)
  end

  def add_delivery_row
    return unless delivery_price_with_vat && delivery_price_with_vat > 0

    product = Product.where(tuoteno: DELIVERY_PRODUCT_NUMBERS)
                     .where('round(myyntihinta * 1.24, 2) >= ?', delivery_price_with_vat)
                     .order(:myyntihinta)
                     .first!

    response = LegacyMethods.pupesoft_function(:lisaa_rivi, order_id: find_draft.id, product_id: product.id)

    find_draft.rows.find(response[:added_row])
  end

  def update_delivery_method_to_nouto
    find_draft.update!(delivery_method: DeliveryMethod.find_by!(selite: 'Nouto'))
  end

  def update_delivery_method_to_itella_economy_16
    find_order.update!(delivery_method: DeliveryMethod.find_by!(selite: 'Itella Economy 16'))
  end

  def mark_as_done
    find_draft.mark_as_done
  end

  private

    def customer_info
      @customer_info ||= begin
        regex = %r{
          Ostajan\syhteystiedot:\s*
          (?<name>.*$)\s*
          (?<email>.*$)\s*
          Puhelin:\s*(?<phone>.*$)\s*
          Osoite:\s*
          (?<address>.*$)\s*
          (?<postcode>\d*)\s*(?<city>.*$)\s*
          (?<country>.*$)
        }x

        extract_info(regex, @doc.content)
      end
    end

    def delivery_info
      @delivery_info ||= begin
        regex = %r{
          Toimitusosoite\s*
          (?<name>.*$)\s*
          (?<address>.*$)\s*
          (?<postcode>\d*)\s*(?<city>.*$)\s*
          (?<phone>.*$)\s*
          (?<email>\S*)
        }x

        extract_info(regex, @doc.content)
      end
    end

    def subject_info
      @subject_info ||= begin
        regex = %r{
          (kohde|kohteen|kohteelle)\s*\#?(?<auction_id>\d*)
        }x

        extract_info(regex, @mail.subject)
      end
    end

    def auction_info
      @auction_info ||= begin
        regex = %r{
          (Kohdenumero|Kohde):?\s*\#?(?<auction_id>\d*)\s*
          Otsikkokenttä:\s*(?<auction_title>.*$)\s*
          Päättymisaika:\s*(?<closing_date>.*$)\s*
          Huudettu:\s*(?<winning_bid>\d*).*$\s*
          (Hintavaraus:.*\s*)?
          Alv-osuus:\s*(?<vat_amount>\d*(\.|,)?\d*).*$\s*
          Summa:\s*(?<price>\d*(\.|,)?\d*).*,\s*
          ALV\s*(?<vat>\d*).*$\s*

          # Delivery cost and total price. Not always present.
          ((Toimitus|Nouto):\s*(?<delivery_price_with_vat>\d*(\.|,)?\d*)\s*\S*\s*
          ALV\s*(?<delivery_vat_percent>\d*(\.|,)?\d*)\s*\S*\s*
          ALV-osuus\s*(?<delivery_vat_amount>\d*(\.|,)?\d*).*$\s*
          Yhteensä:\s*(?<total_price_with_vat>\d*(\.|,)?\d*))?
        }ix

        extract_info(regex, @doc.content)
      end
    end

    def extract_info(regex, document)
      info = {}

      document.match(regex) do |match|
        info = match.names.each_with_object({}) do |name, hash|
          hash[name.to_sym] = match[name]
        end
      end

      info
    end
end
