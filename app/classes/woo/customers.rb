class Woo::Customers < Woo::Base

 # Create customers to woocommerce
  def create
    logger.info "Luodaan wanhat!"
    created_count = 0
    customers.each do |customer|
        logger.info "On asiakas!"
        #if get_sku(customer.woo_website_id)
        #  logger.info "Asiakas #{customer.woo_website_id} on jo verkkokaupassa"
  
        #  next
        #end
        wc_contacts = customer.contacts.where(rooli: "woocommerce")
        logger.info "Kontaktit: #{wc_contacts}"
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

    logger.info "Lisättiin #{created_count} asiakasta verkkokauppaan"
  end

  def create_customer(contact)
    logger.info "#{customer_hash(contact)}"
    response = woo_post('customers', customer_hash(contact))
    logger.info "Response #{response}"
    #logger.info "Asiakas #{contact.customer.ytunnus} #{contact.customer.nimi} lisätty verkkokauppaan"
    return response
  end

  def update_customer(contact)
    #logger.info "#{customer_hash(contact)}"
    url = "customers/"+contact.ulkoinen_asiakasnumero.to_s
    data = customer_hash(contact)
    logger.info "#{url}"
    logger.info "#{data}"
    response = woo_put(url, data)
    logger.info "Response #{response}"
    #logger.info "Asiakas #{contact.customer.ytunnus} #{contact.customer.nimi} lisätty verkkokauppaan"
    #return response
  end

  def customer_hash(contact)
    
     if contact.customer.nimitark.present?
         etunimi = contact.customer.nimitark.split[0]
         sukunimi = contact.customer.nimitark.split[-1]
         firma = contact.customer.nimi
     else
         etunimi = contact.customer.nimi.split[0]
       	 sukunimi = contact.customer.nimi.split[-1]
       	 firma = contact.customer.nimi 
     end
     

     defaults = {
            email: contact.email,
            first_name: etunimi,
            last_name: sukunimi,
            billing: {
                first_name: contact.customer.laskutus_nimi,
                last_name: "",
                company:firma,
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
                company: firma,
                address_1: contact.customer.toim_osoite,
                address_2: "",
                city: contact.customer.toim_postitp,
                postcode: contact.customer.toim_postino,
                country: contact.customer.maa
            }
    }
     
      if contact.customer.ryhma == "2 - Opiskelijat"
      	opiskelija = "kylla"
      else
	opiskelija = ""
      end
      
      if contact.customer.osasto == "3 - Julkinen terveyspalvelu"
      	tyyppi = "julkinen"
        if ["3 - Terveyskeskukset ja sairaalat", "3 - Julkiset palvelutalot", "3 - Julkiset oppilaitokset"].include? contact.customer.ryhma
            julkinen = contact.customer.ryhma
        else
            julkinen =""
        end
        yksityinen = ""
      else 
	tyyppi = "yksityinen"
        if ["2 - Jalkojenhoito-/jalkaterapiapalvelut", "2 - Kosmetologipalvelut", "2 - Fysioterapiapalvelut", "2 - Hierontapalvelut", "4 - Yksityiset oppilaitokset", "2 - Parturit ja kampaamot", "5 - Palvelutalot ja hoitokodit"].include? contact.customer.ryhma
       	    yksityinen = contact.customer.ryhma
        else 
       	    yksityinen = ""
       	end 
       	julkinen = ""
      end

      meta_data = [
        {"key": "form_olen_opiskelija", "value": opiskelija},
        {"key": "form_type", "value": tyyppi},
        {"key": "form_yksityinen", "value": yksityinen},
        {"key": "form_julkinen", "value": julkinen},
        {"key": "form_yritys", "value": firma},
        {"key": "form_y-tunnus", "value": contact.customer.ytunnus},
        {"key": "form_sukunimi", "value": sukunimi},
        {"key": "form_etunimi", "value": etunimi},
        {"key": "form_osoite", "value": contact.customer.osoite},
        {"key": "form_postinumero", "value": contact.customer.postino},
        {"key": "form_postitoimipaikka", "value": contact.customer.postitp},
        {"key": "form_maa", "value": contact.customer.maa},
        {"key": "form_puhelin", "value": contact.customer.puhelin},
      ]
      #logger.info "Meta: #{meta_data}"
      if tyyppi == "julkinen"
         meta_data.delete("form_yksityinen")
      end
      if tyyppi == "yksityinen"
         meta_data.delete("form_julkinen")
      end

      unless meta_data.empty?
        defaults.merge!({meta_data: meta_data})
      end    
      #logger.info "Defaults: #{defaults}"
      return defaults
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

  def activate_customer(id)
    url = "custom/user/approve/#{id}"
    logger.info "#{url}"
    response =  woo_get(url)
    #logger.info "#{response}"
  end

  def get_customer(id)
    response = woo_get('customers', id: id)
    #logger.info "Response: #{response}"
    customer = response.try(:first)

    return if customer.nil? || customer['id'].blank?

    response.first
  end

  def check_active_customers()
    notfound = []
    offsets = (0..3000).step(100).to_a
    offsets.each do |offset|
      url = "customers?per_page=100&offset="+offset.to_s
      response = woo_get(url)
      return unless response
      response.each do |customer|
        mills_user_approved = customer['meta_data'].select {|meta| meta["key"] == '_mills_user_approved'}
        if mills_user_approved[0]["value"] == "1"
          if Contact.where(rooli: "woocommerce").where(ulkoinen_asiakasnumero: customer['id']).exists?
            puts "asiakas #{customer['id']} found!"
          else
            puts "asiakas #{customer['id']} not found!"
            notfound << customer['id']
          end         
        end
      end
    end
    puts notfound
  end



  def create_pupe_customers()

    offsets = (0..7500).step(100).to_a
    offsets.each do |offset|
    url = "customers?per_page=100&offset="+offset.to_s
    #logger.info "#{url}"
    response = woo_get(url)
    
    #logger.info "json: \n\n #{response.to_s}\n\n'"
    return unless response

    response.each do |customer|
    #logger.info "asikaskäsittely!"
    mills_user_approved = customer['meta_data'].select {|meta| meta["key"] == '_mills_user_approved'}
    #logger.info "#{customer}"
    
    if mills_user_approved[0]["value"] == "0"
       logger.info "#{customer}" 
       if Contact.where(rooli: "woocommerce").where(ulkoinen_asiakasnumero: customer['id']).exists?
            
            logger.info "customer loytyi!"
            as_tun = Contact.where(rooli: "woocommerce").where(ulkoinen_asiakasnumero: customer['id']).first.liitostunnus
            asiakas = Customer.unscoped.where(tunnus: as_tun).first
            logger.info "laji on (#{asiakas.laji})"
            if asiakas.laji == 'R'
                logger.info "prospekti"
            end
            if asiakas.laji == '' or asiakas.laji == ' ' or asiakas.laji == 'H'
               logger.info "aktivoidaan!" 
               activate_customer(customer['id'])
            end
        else              
                logger.info"customeria ei loydy!"
                #logger.info"#{customer}"
                opisk = customer['meta_data'].select {|meta| meta["key"] == 'form_olen_opiskelija'}
                tyyppi = customer['meta_data'].select {|meta| meta["key"] == 'form_type'}

                logger.info "#{tyyppi}"                

                #if tyyppi.kind_of?(Array)
                #  if tyyppi[0]["value"] = "julkinen"
                #   f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_julkinen'}
                #  elsif tyyppi[0]["value"] = "yksityinen"
       	       	#   f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_yksityinen'}
                #  end
                #else
                #  f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_julkinen'}
                #end

                if opisk[0]["value"].kind_of?(Array)
                    logger.info "Opiskelija"
                    s_nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_sukunimi'}
                    e_nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_etunimi'}
                    oppilaitos = customer['meta_data'].select {|meta| meta["key"] == 'form_oppilaitos'}
                    piiri = oppilaitos[0]["value"]
                    #logger.info"suku #{s_nimi} etu #{e_nimi}"
                    nimi = e_nimi[0]["value"] + " " + s_nimi[0]["value"]
                    nimitarkenne = ""
                    ytunnus = '99999999'
                    email = customer['email']
                    osoite = customer['meta_data'].select {|meta| meta["key"] == 'form_osoite'}
                    postino = customer['meta_data'].select {|meta| meta["key"] == 'form_postinumero'}
                    postitp = customer['meta_data'].select {|meta| meta["key"] == 'form_postitoimipaikka'}
                    maa = customer['meta_data'].select {|meta| meta["key"] == 'form_maa'}
                    ryhma = "2 - Opiskelijat" 
                else
                    logger.info "Firma"

                                    if tyyppi.kind_of?(Array)
                  if tyyppi[0]["value"] == "julkinen"
                   logger.info "Julkinen!"
                   f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_julkinen'}
                  elsif tyyppi[0]["value"] == "yksityinen"
                   logger.info "Yksityinen!"
                   f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_yksityinen'}
                  end
                else
                  logger.info "Else!"
                  f_ryhma = customer['meta_data'].select {|meta| meta["key"] == 'form_julkinen'}
                end
                  logger.info"#{f_ryhma}"                    

                    f_nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_yritys'}
                    nimi = f_nimi[0]["value"][0..59]
                    s_nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_sukunimi'}
                    e_nimi = customer['meta_data'].select {|meta| meta["key"] == 'form_etunimi'}
                    nimitarkenne = e_nimi[0]["value"] + " " + s_nimi[0]["value"]
                    form_ytunnus = customer['meta_data'].select {|meta| meta["key"] == 'form_y-tunnus'}
                    ytunnus = form_ytunnus[0]["value"][0..14]
                    email = customer['email']
                    osoite = customer['meta_data'].select {|meta| meta["key"] == 'form_osoite'}
                    postino = customer['meta_data'].select {|meta| meta["key"] == 'form_postinumero'}
                    postitp = customer['meta_data'].select {|meta| meta["key"] == 'form_postitoimipaikka'}
                    maa = customer['meta_data'].select {|meta| meta["key"] == 'form_maa'}
                    ryhma = f_ryhma[0]["value"]
                    piiri = ""
                end

                case ryhma
                  when "3 - Terveyskeskukset ja sairaalat", "3 - Julkiset palvelutalot", "3 - Julkiset oppilaitokset"
                    osasto = "3 - Julkinen terveyspalvelu"
                  when "2 - Jalkojenhoito-/jalkaterapiapalvelut", "2 - Kosmetologipalvelut", "2 - Fysioterapiapalvelut", "2 - Hierontapalvelut", "2 - Parturit ja kampaamot", "2 - Opiskelijat"
                    osasto = "2 - Yrittäjäasiakkaat"
                  when "1 - Pääapteekki"
                    osasto = "1 - Apteekki"
                  when "4 - Yksityiset oppilaitokset"
                    osasto = "4 - Yksityinen terveyspalvelu"
                  when "5 - Palvelutalot ja hoitokodit"
                    osasto = "5 - Liitot/yhdistykset/säätiöt"
                  else
                    osasto = "2 - Yrittäjäasiakkaat"
                end

                #puts nimi + ytunnus + email + osoite + postino + postitp + maa

                if ytunnus != '99999999'
                    logger.info "#{ytunnus}"
                    pupe_customers = Customer.where(ytunnus: [ytunnus.tr('-',''),ytunnus])
                else
                    pupe_customers = Customer.where(email: email)
                end

                if pupe_customers.length == 1
                    pupe_customer = pupe_customers.first
                    logger.info "loytyi #{pupe_customer}"
                else

                    numero = 20000
                    while Customer.unscoped.exists? asiakasnro: numero
                      numero = numero+1
                    end

                    if maa[0]["value"] == 'FI'
                      alvi = 24.0
                    else
                      alvi = 0.0
                    end

                    logger.info "#{maa[0]["value"]}#{alvi}"

                    pupe_customer = Customer.new(
                    nimi: nimi,
                    nimitark: nimitarkenne,
                    ytunnus: ytunnus,
                    email: email,
                    osoite: osoite[0]["value"],
                    postino: postino[0]["value"],
                    postitp: postitp[0]["value"],
                    maa: maa[0]["value"],
                    kauppatapahtuman_luonne: 0,
                    alv: alvi,
                    yhtio: 'mills',
                    laji: 'R',
                    ryhma: ryhma,
                    osasto: osasto,
                    piiri: piiri,
                    asiakasnro: numero
                    )
                    pupe_customer.save(validate: false)
                end

                    pupe_contact = Contact.new(
                    nimi: nimi[0..49],
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
 end
  
  def customers
    Customer.includes(:contacts).where("yhteyshenkilo.rooli" => "Woocommerce")
  end

end
