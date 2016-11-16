class HuutokauppaMail
  attr_reader :mail, :messages

  DELIVERY_PRODUCT_NUMBERS = (90..95).to_a + (90..95).to_a.map { |e| "#{e}MAX" }

  def initialize(raw_source)
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @mail     = Mail.new(raw_source)
    @doc      = Nokogiri::HTML(@mail.body.to_s.force_encoding(Encoding::UTF_8))
    @messages = []
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

  def company_name
    customer_info[:company_name]
  end

  def company_id
    customer_info[:company_id]
  end

  def customer_name
    customer_info[:name]
  end

  def name
    parse_value (company_name || customer_name), 60
  end

  def customer_email
    parse_value customer_info[:email], 100
  end

  def customer_phone
    parse_value customer_info[:phone], 50
  end

  def customer_address
    parse_value customer_info[:address], 55
  end

  def customer_postcode
    parse_value customer_info[:postcode], 35
  end

  def customer_city
    parse_value customer_info[:city], 35
  end

  def customer_country
    customer_info[:country]
  end

  def delivery_name
    parse_value delivery_info[:name], 60
  end

  def delivery_address
    parse_value delivery_info[:address], 55
  end

  def delivery_postcode
    parse_value delivery_info[:postcode], 35
  end

  def delivery_city
    parse_value delivery_info[:city], 35
  end

  def delivery_phone
    parse_value delivery_info[:phone], 50
  end

  def delivery_email
    parse_value delivery_info[:email], 100
  end

  def delivery_price_without_vat
    return unless delivery_price_with_vat

    delivery_price_with_vat - delivery_vat_amount
  end

  def delivery_price_with_vat
    return unless auction_info[:delivery_price_with_vat]

    format_decimal auction_info[:delivery_price_with_vat]
  end

  def delivery_vat_percent
    return unless auction_info[:delivery_vat_percent]

    format_decimal auction_info[:delivery_vat_percent]
  end

  def delivery_vat_amount
    return unless auction_info[:delivery_vat_amount]

    format_decimal auction_info[:delivery_vat_amount]
  end

  def total_price_with_vat
    return auction_price_with_vat unless auction_info[:total_price_with_vat]

    format_decimal auction_info[:total_price_with_vat]
  end

  def auction_id
    subject_info[:auction_id]
  end

  def auction_title
    auction_info[:auction_title]
  end

  def auction_closing_date
    Time.zone.parse(auction_info[:closing_date])
  end

  def auction_price_without_vat
    format_decimal auction_info[:winning_bid]
  end

  def auction_price_with_vat
    format_decimal auction_info[:price]
  end

  def auction_vat_percent
    format_decimal auction_info[:vat]
  end

  def auction_vat_amount
    format_decimal auction_info[:vat_amount]
  end

  def find_customer
    @customer ||= Customer.find_by(email: customer_email) if customer_email
  end

  def create_customer
    return unless name

    customer = Customer.new(
      email: customer_email,
      gsm: customer_phone,
      kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
      nimi: name,
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
      ytunnus: company_id || "HK#{auction_id}",
      delivery_method: DeliveryMethod.find_by!(selite: 'Nouto'),
      terms_of_payment: TermsOfPayment.find_by!(rel_pvm: 2),
      chn: 667,
      piiri: 1,
      category: Keyword::CustomerCategory.find_by!(selite: 1),
      alv: 24,
    )

    customer.laji = 'H' unless company_name

    if customer.save
      @messages << "Asiakas #{customer_message_info(customer)} luotu."
      return customer
    end

    @messages << "Asiakkaan #{customer_message_info(customer)} luonti epäonnistui. " \
                 "Virheilmoitus: #{customer.errors.full_messages.to_sentence}."
    customer
  end

  def update_customer
    return unless find_customer

    update_success = find_customer.update(
      nimi: name,
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
      gsm: customer_phone,
      piiri: 1,
      kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
      category: Keyword::CustomerCategory.find_by!(selite: 1),
    )

    if update_success
      @messages << "Asiakas #{customer_message_info(find_customer)} päivitetty."
      return true
    end

    @messages << "Asiakkaan #{customer_message_info(find_customer)} tietojen päivitys epäonnistui. " \
                 "Virheilmoitus: #{find_customer.errors.full_messages.to_sentence}."
    false
  end

  def update_or_create_customer
    return unless find_draft

    if find_customer
      @messages << "Asiakas #{customer_message_info(find_customer)} löytyi, joten päivitetään kyseisen asiakkaan tiedot."

      update_customer

      customer = find_customer
    else
      customer = create_customer
    end

    if customer.valid?
      find_draft.update!(customer: customer)
    else
      @messages << 'Asiakkaan tiedot virheelliset, ei voida päivittää asiakasta tilaukselle.' \
                   "#{order_message_info(find_draft)} " \
                   "Virheilmoitus: #{customer.errors.full_messages.to_sentence}."
    end

    customer
  end

  def find_draft
    @draft ||= SalesOrder::Draft.find_by(viesti: auction_id)

    unless @draft
      raise ActiveRecord::RecordNotFound, "Kesken olevaa myyntitilausta ei löytynyt huutokaupalle #{auction_id}."
    end

    @draft
  end

  def find_order
    @order ||= SalesOrder::Order.find_by(viesti: auction_id)

    return @order if @order

    @messages << "Myyntitilausta ei löytynyt huutokaupalle #{auction_id}."
    nil
  end

  def update_order_customer_info
    return unless name && find_draft

    find_draft.update!(
      nimi: name,
      nimitark: '',
      osoite: customer_address,
      postino: customer_postcode,
      postitp: customer_city,
      puh: customer_phone,
      email: customer_email,
      ytunnus: company_id || auction_id,

      toim_nimi: name,
      toim_nimitark: '',
      toim_osoite: customer_address,
      toim_postino: customer_postcode,
      toim_postitp: customer_city,
      toim_puh: customer_phone,
      toim_email: customer_email,
    )

    find_draft.detail.update!(
      laskutus_nimi: name,
      laskutus_nimitark: '',
      laskutus_osoite: customer_address,
      laskutus_postino: customer_postcode,
      laskutus_postitp: customer_city,
    )

    @messages << "Päivitettiin tilauksen #{order_message_info(find_draft)} asiakastiedot."

    true
  end

  def update_order_delivery_info
    return unless delivery_name && find_draft

    find_draft.update!(
      toim_email: delivery_email,
      toim_nimi: delivery_name,
      toim_osoite: delivery_address,
      toim_postino: delivery_postcode,
      toim_postitp: delivery_city,
      toim_puh: delivery_phone,
    )

    @messages << "Päivitettiin tilauksen #{order_message_info(find_draft)} toimitustiedot."

    true
  end

  def update_order_product_info
    return unless find_draft

    row = find_draft.rows.first
    qty = row.tilkpl

    row.update!(
      alv: auction_vat_percent,
      hinta: auction_price_without_vat / qty,
      hinta_alkuperainen: auction_price_without_vat / qty,
      hinta_valuutassa: auction_price_without_vat / qty,
      nimitys: auction_title,
      rivihinta: auction_price_without_vat,
      rivihinta_valuutassa: auction_price_without_vat,
    )

    if row.parent?
      child_row_ids = find_draft.rows.where.not(tunnus: row.tunnus).pluck(:tunnus)
      LegacyMethods.pupesoft_function(:tuoteperheiden_hintojen_paivitys, parent_row_ids: { row.id => child_row_ids })
    end

    @messages << "Päivitettiin tilauksen #{order_message_info(find_draft)} tuotetiedot (Tuoteno: #{row.tuoteno}, Hinta: #{row.hinta})."

    true
  end

  def create_sales_order
    return unless customer_name

    customer_id = find_customer.try(:id) || create_customer.id

    response = LegacyMethods.pupesoft_function(:luo_myyntitilausotsikko, customer_id: customer_id)
    sales_order_id = response[:sales_order_id]

    SalesOrder::Draft.find(sales_order_id)
  end

  def add_delivery_row
    return unless find_draft && delivery_price_with_vat && delivery_price_with_vat > 0

    product = Product.where(tuoteno: DELIVERY_PRODUCT_NUMBERS)
      .where('round(myyntihinta * 1.24, 2) >= ?', delivery_price_with_vat)
      .order(:myyntihinta)
      .first!

    @messages << "Löydettiin tuote (Tuoteno: #{product.tuoteno}, Hinta: #{product.myyntihinta}) lisättäväksi toimitustuotteeksi."

    response = LegacyMethods.pupesoft_function(:lisaa_rivi, order_id: find_draft.id, product_id: product.id)

    row = find_draft.rows.find(response[:added_row])

    @messages << "Lisättiin toimitusrivi tilaukselle #{order_message_info(find_draft)}."

    row
  end

  def update_delivery_method_to_nouto
    return unless find_draft

    find_draft.update!(delivery_method: DeliveryMethod.find_by!(selite: 'Nouto'))

    @messages << "Päivitettiin tilauksen #{order_message_info(find_draft)} toimitustavaksi Nouto."

    true
  end

  def update_delivery_method_to_itella_economy_16
    return unless find_draft

    find_draft.update!(delivery_method: DeliveryMethod.find_by!(selite: 'Posti Economy 16'))

    @messages << "Päivitettiin tilauksen #{order_message_info(find_draft)} toimitustavaksi Posti Economy 16."

    true
  end

  def mark_as_done
    return unless find_draft

    create_preliminary_invoice = find_draft.jaksotettu.zero?

    @messages <<
      if create_preliminary_invoice
        "Luodaan ennakkolasku tilaukselle #{order_message_info(find_draft)}."
      else
        "Ei luoda ennakkolaskua tilaukselle #{order_message_info(find_draft)}, sillä se on jo luotu."
      end

    response = find_draft.mark_as_done(create_preliminary_invoice: create_preliminary_invoice)

    @messages << "Merkittiin tilaus #{order_message_info(find_draft)} valmiiksi."

    response
  end

  private

    def customer_info
      @customer_info ||= begin
        regex = %r{
          Ostajan\syhteystiedot:\s*
          (Yritys:\s*
          (?<company_name>.*$)\s*
          (?<company_id>.*$)\s*)?
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
        currency_number = /(\d|[[:space:]])*(\.|\,)?\d*/

        regex = %r{
          (Kohdenumero|Kohde):?\s*\#?(?<auction_id>\d*)\s*
          Otsikkokenttä:\s*(\d+\.\d+\.-\d+.\d+\.\s*)?(?<auction_title>.*$)\s*
          Päättymisaika:\s*(?<closing_date>.*$)\s*
          Huudettu:\s*(?<winning_bid>#{currency_number}).*$\s*
          (Hintavaraus:.*\s*)?
          Alv-osuus:\s*(?<vat_amount>#{currency_number}).*$\s*
          Summa:\s*(?<price>#{currency_number}).*,\s*
          ALV\s*(?<vat>#{currency_number}).*$\s*

          # Delivery cost and total price. Not always present.
          ((Toimitus|Nouto):\s*(?<delivery_price_with_vat>#{currency_number})\s*\S*\s*
          ALV\s*(?<delivery_vat_percent>#{currency_number})\s*\S*\s*
          ALV-osuus\s*(?<delivery_vat_amount>#{currency_number}).*$\s*
          Yhteensä:\s*(?<total_price_with_vat>#{currency_number}))?
        }ix

        extract_info(regex, @doc.content)
      end
    end

    def format_decimal(value)
      value.to_s.sub(',', '.').gsub(/[[:space:]]+/, '').to_d
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

    def customer_message_info(customer)
      "#{customer.nimi} (#{customer.email})"
    end

    def order_message_info(order)
      "(Tilausnumero: #{order.id}, Huutokauppa: #{auction_id})"
    end

    def parse_value(value, max_length)
      return unless value

      value.to_s[0, max_length]
    end
end
