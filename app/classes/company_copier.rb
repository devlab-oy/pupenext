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
    create_customers

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
      duplicate :accounts
      duplicate :currencies
      duplicate :delivery_methods
      duplicate :keywords
      duplicate :parameter, attributes: default_parameter_attributes
      duplicate :permissions, attributes: default_permission_attributes
      duplicate :printers
      duplicate :sum_levels
      duplicate :terms_of_payments
      duplicate :users
      duplicate :warehouses
    end

    def duplicate(model, attributes: {})
      Current.company = from_company

      records = from_company.send model
      records = [records] unless records.respond_to?(:map)

      records.map do |record|
        Current.company = new_company

        copy = record.dup
        copy.assign_attributes attributes.merge(default_attributes)
        copy.save! validate: false
        copy
      end
    end

    def create_customers
      customer_companies.each do |company|
        Current.company = company

        customer = Customer.create!(
          nimi: new_company.nimi,
          ytunnus: new_company.ytunnus,
          kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
          alv: Keyword::Vat.first.selite,
        )

        create_users_for customer
      end
    end

    def create_users_for(customer)
      return if association_params[:users_attributes].blank?

      association_params[:users_attributes].each do |user_params|
        user_params = user_params.merge(
          kuka: user_params[:kuka],
          extranet: 'X',
          profiilit: 'Extranet',
          oletus_profiili: 'Extranet',
          oletus_asiakas: customer.id,
          oletus_asiakastiedot: customer.id,
        )

        User.create!(user_params)
      end
    end

    # TODO: This can be achieved much easier with a db transaction.
    # When those are supported, this should be refactored.
    def delete_partial_data
      destroy :accounts
      destroy :currencies
      destroy :delivery_methods
      destroy :keywords
      destroy :parameter
      destroy :permissions
      destroy :printers
      destroy :sum_levels
      destroy :terms_of_payments
      destroy :users
      destroy :warehouses

      Current.company = new_company
      new_company.destroy!
    end

    def destroy(model)
      Current.company = new_company
      records = new_company.send(model)

      records.destroy_all if records.respond_to?(:destroy_all)
      records.delete if records.respond_to?(:delete)
    end

    def company_params
      @to_company_params.reject { |attribute| attribute.match(/_attributes$/) }
    end

    def association_params
      @to_company_params.select { |attribute| attribute.match(/_attributes$/) }
    end

    def customer_companies
      Company.where(yhtio: @customer_companies)
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

    def default_permission_attributes
      {
        user: new_company.users.find_by(kuka: :admin),
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
      new_company.assign_attributes company_params
      new_company.assign_attributes association_params
      new_company.save! validate: true

      @new_company = new_company
    end
end
