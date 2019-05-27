class Woo::Customers < Woo::Base

  # Create customers to woocommerce
  def create

    created_count = 0
    customers.each do |customer|
        if get_sku(customer.woo_website_id)
          logger.info "Asiakas #{customer.woo_website_id} on jo verkkokaupassa"
  
          next
        end
  
        created_count += create_customer(customer)
    end

    logger.info "Lisättiin #{created_count} asiakasta verkkokauppaan"
  end

  def create_customer(customer)
    response = woo_post('customers', customer_hash(customer))
    logger.info "Asiakas #{customer.ytunnus} #{customer.nimi} lisätty verkkokauppaan"
    return response
  end

  def customer_hash(customer)
    defaults = {
            email: customer.yhenk_email,
            first_name: customer.nimi,
            last_name: customer.nimi,
            vat_number: customer.ytunnus,
            billing_address: {
                first_name: customer.laskutus_nimi,
                last_name: customer.laskutus_nimi,
                company:customer.nimi,
                address_1: customer.laskutus_osoite,
                address_2: "",
                city: customer.laskutus_postitp,
                postcode: customer.laskutus_postino,
                country: customer.maa,
                email: customer.yhenk_email,
                phone: customer.yhenk_puh
            },
            shipping_address: {
                first_name: customer.toimitus_nimi,
                last_name: customer.toiumitus_nimi,
                company: customer.nimi,
                address_1: customer.toimitus_osoite,
                address_2: "",
                city: customer.toimitus_postit,
                postcode: customer.toimitus_postino,
                country: customer.maa
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

end