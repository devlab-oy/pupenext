class Woo::Customers < Woo::Base

  # Create customers to woocommerce
  def create

    created_count = 0
    customers.each do |customer|
        #if get_sku(customer.woo_website_id)
        #  logger.info "Asiakas #{customer.woo_website_id} on jo verkkokaupassa"
  
        #  next
        #end
        wc_contacts = customer.contacts.where(rooli: "woocommerce")
        wc_contacts.each do |contact| 
          if contact.ulkoinen_asiakasnumero.present?
            logger.info "Asiakas #{contact.ulkoinen_asiakasnumero} on jo verkkokaupassa"
            next
          end
          logger.info "Luodaan woohon asiakas #{contact}"
          new_customer = create_customer(contact)
          logger.info "New Customer: #{new_customer}"
          logger.info "ID: #{new_customer["id"]}"
          contact.ulkoinen_asiakasnumero = new_customer["id"]
          logger.info "Contact: #{contact.ulkoinen_asiakasnumero}"
          contact.save(validate: false)
        end
    end

    #logger.info "Lisättiin #{created_count} asiakasta verkkokauppaan"
  end

  def create_customer(contact)
    logger.info "#{customer_hash(contact)}"
    response = woo_post('customers', customer_hash(contact))
    logger.info "Response #{response}"
    #logger.info "Asiakas #{contact.customer.ytunnus} #{contact.customer.nimi} lisätty verkkokauppaan"
    return response
  end

  def customer_hash(contact)
    defaults = {
            email: contact.email,
            first_name: contact.customer.nimi,
            last_name: "",
            vat_number: contact.customer.ytunnus,
            billing: {
                first_name: contact.customer.laskutus_nimi,
                last_name: "",
                company:contact.customer.nimi,
                address_1: contact.customer.laskutus_osoite,
                address_2: "",
                city: contact.customer.laskutus_postitp,
                postcode: contact.customer.laskutus_postino,
                country: contact.customer.maa,
                email: contact.email,
                phone: contact.puh
            },
            shipping: {
                first_name: contact.customer.toim_nimi,
                last_name: "",
                company: contact.customer.nimi,
                address_1: contact.customer.toim_osoite,
                address_2: "",
                city: contact.customer.toim_postitp,
                postcode: contact.customer.toim_postino,
                country: contact.customer.maa
            }
    }    
  end

  def customer_batch()

    customers = [
        {
      "email": "john.doe2@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "username": "john.doe2",
      "billing": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "",
        "address_1": "969 Market",
        "address_2": "",
        "city": "San Francisco",
        "state": "CA",
        "postcode": "94103",
        "country": "US",
        "email": "john.doe@example.com",
        "phone": "(555) 555-5555"
      },
      "shipping": {
        "first_name": "John",
        "last_name": "Doe",
        "company": "",
        "address_1": "969 Market",
        "address_2": "",
        "city": "San Francisco",
        "state": "CA",
        "postcode": "94103",
        "country": "US"
      }
    },
    {
      "email": "joao.silva2@example.com",
      "first_name": "João",
      "last_name": "Silva",
      "username": "joao.silva2",
      "billing": {
        "first_name": "João",
        "last_name": "Silva",
        "company": "",
        "address_1": "Av. Brasil, 432",
        "address_2": "",
        "city": "Rio de Janeiro",
        "state": "RJ",
        "postcode": "12345-000",
        "country": "BR",
        "email": "joao.silva@example.com",
        "phone": "(55) 5555-5555"
      },
      "shipping": {
        "first_name": "João",
        "last_name": "Silva",
        "company": "",
        "address_1": "Av. Brasil, 432",
        "address_2": "",
        "city": "Rio de Janeiro",
        "state": "RJ",
        "postcode": "12345-000",
        "country": "BR"
      }
    }
    ]

    defaults = {
        create: customers
    }
  end

  def get_customer(id)
    response = woo_get('customers', id: id)
    logger.info "Response: #{response}"
    customer = response.try(:first)

    return if customer.nil? || customer['id'].blank?

    response.first
  end

  def create_pupe_customers()
    response = woo_get('customers')
    
    logger.info "json: \n\n #{response.to_s}\n\n'"
    return unless response

    response.each do |customer|
    if customer['_mills_user_approved'] == 0
        if Contact.where(rooli: "woocommerce").where(ulkoinen_asiakasnumero: customer.id).exists?
            
            asiakas = Contact.where(rooli: "woocommerce").where(ulkoinen_asiakasnumero: 19).first.customer

            if asiakas.tila == 'R'
                return 0
            elif asiakas.tila == "" or asiaks.tila == "H"
                return 1
            end
        else              
                opisk = customer['meta_data'].select {|meta| meta["key"] == 'form_olen_opiskelija'}

                if opisk[0]["value"].kind_of?(Array)
                    puts "Opiskelija"
                    nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_sukunimi'}
                    ytunnus = '99999999'
                    email = customer['email']
                    osoite = customer['meta_data'].select {|meta| meta["key"] == 'form_osoite'}
                    postino = customer['meta_data'].select {|meta| meta["key"] == 'form_postinumero'}
                    postitp = customer['meta_data'].select {|meta| meta["key"] == 'form_postitoimipaikka'}
                    maa = 'FI'
                else
                puts "Firma"
                    nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_yritys'}
                    form_ytunnus = customer['meta_data'].select {|meta| meta["key"] == 'form_y-tunnus'}
                    ytunnus = form_ytunnus[0]["value"]
                    email = customer['email']
                    osoite = customer['meta_data'].select {|meta| meta["key"] == 'form_osoite'}
                    postino = customer['meta_data'].select {|meta| meta["key"] == 'form_postinumero'}
                    postitp = customer['meta_data'].select {|meta| meta["key"] == 'form_postitoimipaikka'}
                    maa = 'FI'
                end

                #puts nimi + ytunnus + email + osoite + postino + postitp + maa

                    pupe_customer = Customer.new(
                    nimi: nimi[0]["value"],
                    ytunnus: ytunnus,
                    email: email,
                    osoite: osoite[0]["value"],
                    postino: postino[0]["value"],
                    postitp: postitp[0]["value"],
                    maa: maa,
                    kauppatapahtuman_luonne: 0,
                    alv: Keyword::Vat.first.selite,
                    yhtio: 'mills',
                    laji: 'R'
                    )
                pupe_customer.save(validate: false)

                    pupe_contact = Contact.new(
                    nimi: nimi[0]["value"],
                    rooli: "Woocommerce",
                    email: email,
                    ulkoinen_asiakasnumero: customer['id'],
                    liitostunnus: pupe_customer.tunnus,
                    tyyppi: 'A'
                    )

                pupe_contact.save(validate: false)
        end
      end
    end    
 end
  
  def customers
    Customer.includes(:contacts).where("yhteyshenkilo.rooli" => "Woocommerce")
  end

end
