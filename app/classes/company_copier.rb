# from_company yrityksen tiedot duplikoidaan to_companyyn (kts duplicate_data)
# to_company_params sallii nested attribuutteja (kts Company -model)
# customer_companies sisältää Pupesoftin yhtiökoodeja, joihin to_company perustetaan asiakkaaksi
class CompanyCopier
  attr_reader :from_company

  def initialize(from_company: nil, to_company_params: {}, customer_companies: [])
    @original_current_company = Current.company
    @from_company = Current.company = from_company
    @to_company_params = to_company_params
    @customer_companies = customer_companies

    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user
  ensure
    Current.company = @original_current_company
  end

  def copy
    copied_company = new_company
    duplicate_data
    create_as_customer
    update_user_permissions
    copied_company
  rescue ActiveRecord::RecordInvalid => e
    return e.record unless defined?(copied_company) && copied_company

    delete_partial_data

    return e.record
  rescue
    raise unless defined?(copied_company) && copied_company

    delete_partial_data

    raise
  ensure
    Current.company = @original_current_company
  end

  private

    def duplicate_data
      # these need to be duplicated in this order, otherwise relations are incorrect
      duplicate :parameter, attributes: default_parameter_attributes
      duplicate :keywords
      duplicate :sum_levels
      duplicate :menus
      duplicate :user_profiles
      duplicate :users
      duplicate :currencies
      duplicate :warehouses
      duplicate :accounts
      duplicate :delivery_methods
      duplicate :terms_of_payments
      duplicate :customers
      duplicate :printers
    end

    def duplicate(model, attributes: {})
      Current.company = from_company

      records = from_company.send model
      records = [records] unless records.respond_to?(:map)

      records.map do |record|
        Current.company = new_company

        copy = record.dup
        copy.assign_attributes attributes.merge(default_attributes)
        copy.save!
        copy
      end
    end

    # TODO: This can be achieved much easier with a db transaction.
    # When those are supported, this should be refactored.
    def delete_partial_data
      destroy :accounts
      destroy :currencies
      destroy :customers
      destroy :delivery_methods
      destroy :keywords
      destroy :menus
      destroy :parameter
      destroy :permissions # permissions need to be destroyed, even if we dont duplicate
      destroy :printers
      destroy :sum_levels
      destroy :terms_of_payments
      destroy :user_profiles
      destroy :users
      destroy :warehouses

      new_company.destroy!
    end

    def destroy(model)
      Current.company = new_company
      records = new_company.send(model)

      records.destroy_all if records.respond_to?(:destroy_all)
      records.delete if records.respond_to?(:delete)
    end

    def default_parameter_attributes
      {
        finvoice_senderpartyid: '',
        finvoice_senderintermediator: '',
        verkkotunnus_vas: '',
        verkkotunnus_lah: '',
        verkkosala_vas: '',
        verkkosala_lah: '',
        lasku_tulostin: 0,
        logo: '',
        lasku_logo: '',
        lasku_logo_positio: '',
        lasku_logo_koko: 0,
      }
    end

    def default_attributes
      {
        company:    new_company,
        laatija:    nil,
        luontiaika: nil,
        muutospvm:  nil,
        muuttaja:   nil,
      }
    end

    def new_company
      return @new_company if @new_company

      new_company = from_company.dup
      new_company.assign_attributes @to_company_params

      Current.company = new_company
      new_company.save!

      @new_company = new_company
    end

    def create_as_customer
      # creates to_company as customer to given companies
      customer_companies.each do |company|
        Current.company = company

        customer = Customer.create!(
          nimi: new_company.nimi,
          ytunnus: new_company.ytunnus,
          email: user_attributes.map { |h| h[:kuka] }.join(', '),
          kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
          alv: Keyword::Vat.first.selite,
        )

        # all users created to to_company are also created as extranet users to customer_companies
        create_extranet_user customer
      end
    end

    def customer_companies
      Company.where(yhtio: @customer_companies)
    end

    def create_extranet_user(customer)
      return if user_attributes.blank?

      Current.company = customer.company

      user_attributes.each do |user_params|
        user = user_params.merge(
          extranet: 'X',
          profiilit: 'Extranet',
          oletus_profiili: 'Extranet',
          oletus_asiakas: customer.id,
          oletus_asiakastiedot: customer.id,
        )

        new_user = User.create! user
        new_user.update_permissions
      end
    end

    def user_attributes
      users = @to_company_params.select { |p| p.match(/users_attributes$/) }

      users[:users_attributes] || []
    end

    def update_user_permissions
      Current.company = new_company

      # update permissions for all users
      new_company.users.find_each(&:update_permissions)
    end
end
