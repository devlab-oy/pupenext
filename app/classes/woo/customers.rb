class Woo::Customers < Woo::Base

  # Create customers to woocommerce
  def create

    created_count = 0
    customers.each do |customer|
        #if get_sku(customer.woo_website_id)
        #  logger.info "Asiakas #{customer.woo_website_id} on jo verkkokaupassa"
  
        #  next
        #end
        wc_contact = customer.contacts.where(rooli: "woocommerce").first 
        created_count += create_customer(wc_contact)
    end

    logger.info "Lisättiin #{created_count} asiakasta verkkokauppaan"
  end

  def create_customer(contact)
    response = woo_post('customers', customer_hash(contact))
    logger.info "Asiakas #{contact.customer.ytunnus} #{contact.customer.nimi} lisätty verkkokauppaan"
    return response
  end

  def customer_hash(contact)
    defaults = {
            email: contact.email,
            first_name: contact.customer.nimi,
            last_name: contact.customer.nimi,
            vat_number: contact.customer.ytunnus,
            billing_address: {
                first_name: contact.customer.laskutus_nimi,
                last_name: contact.customer.laskutus_nimi,
                company:contact.customer.nimi,
                address_1: contact.customer.laskutus_osoite,
                address_2: "",
                city: contact.customer.laskutus_postitp,
                postcode: contact.customer.laskutus_postino,
                country: contact.customer.maa,
                email: contact.email,
                phone: contact.puh
            },
            shipping_address: {
                first_name: contact.customer.toimitus_nimi,
                last_name: contact.customer.toiumitus_nimi,
                company: contact.customer.nimi,
                address_1: contact.customer.toimitus_osoite,
                address_2: "",
                city: contact.customer.toimitus_postit,
                postcode: contact.customer.toimitus_postino,
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
    response = woo_get('customers', sku: sku)
    customer = response.try(:first)

    return if customer.nil? || customer['id'].blank?

    response.first
  end
  
  def customers
    Customer.includes(:contacts).where("yhteyshenkilo.rooli" => "Woocommerce")
  end

end