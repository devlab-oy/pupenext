# from_company yrityksen tiedot duplikoidaan to_companyyn (kts duplicate_data)
# to_company_params sallii nested attribuutteja (kts Company -model)
# customer_companies sisältää Pupesoftin yhtiökoodeja, joihin to_company perustetaan asiakkaaksi
# supplier_companies sisältää Pupesoftin yhtiökoodeja, joihin to_company perustetaan toimittajaksi
class CompanyCopier
  attr_reader :from_company, :errors

  def initialize(from_company: nil, to_company_params: {}, customer_companies: [], supplier_companies: [])
    @original_current_company = Current.company
    @from_company = Current.company = from_company
    @to_company_params = to_company_params
    @customer_companies = customer_companies
    @supplier_companies = supplier_companies
    @errors = []

    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user
  ensure
    Current.company = @original_current_company
  end

  def copy
    copied_company = new_company

    unless copied_company.valid?
      @errors << copied_company.errors.full_messages

      return self
    end

    duplicate_data
    update_nested_attributes
    create_as_customer
    create_as_supplier
    update_user_permissions
    write_css
    delete_partial_data if errors.present?

    self
  rescue
    delete_partial_data

    self
  ensure
    Current.company = @original_current_company
  end

  def copied_company
    @new_company
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
      duplicate :printers
      duplicate :warehouses, attributes: default_warehouse_attributes
      duplicate :accounts
      duplicate :delivery_methods
      duplicate :terms_of_payments
      duplicate :customers, attributes: { kauppatapahtuman_luonne: 0 }
    end

    def duplicate(model, attributes: {})
      Current.company = from_company

      records = from_company.send model
      records = [records] unless records.respond_to?(:map)

      records.map do |record|
        Current.company = new_company

        copy = record.dup
        copy.assign_attributes attributes.merge(default_attributes)
        copy.save

        @errors << copy.errors.full_messages unless copy.valid?
      end
    end

    # TODO: This can be achieved much easier with a db transaction.
    # When those are supported, this should be refactored.
    def delete_partial_data
      destroy :accounts
      destroy :bank_accounts
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

      new_company.destroy
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

    def default_warehouse_attributes
      Warehouse::PRINTER_NUMBERS.each_with_object({}) { |i, a| a["printteri#{i}"] = Printer.first }
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
      new_company.assign_attributes company_attributes

      Current.company = new_company
      new_company.save

      @new_company = new_company
    end

    def create_as_customer
      # creates to_company as customer to given companies
      customer_companies.each do |company|
        Current.company = company

        customer = Customer.create(
          nimi: new_company.nimi,
          ytunnus: new_company.ytunnus,
          email: user_email,
          kauppatapahtuman_luonne: 0,
          alv: Keyword::Vat.first.selite,
        )

        # all users created to to_company are also created as extranet users to customer_companies
        if customer.valid?
          create_extranet_user customer
        else
          @errors << customer.errors.full_messages
        end
      end
    end

    def create_as_supplier
      # creates to_company as supplier to given companies
      supplier_companies.each do |company|
        Current.company = company

        sup = Supplier.create(
          nimi: new_company.nimi,
          ytunnus: new_company.ytunnus,
          oletus_valkoodi: new_company.valkoodi,
          maa: new_company.maa,
          ultilno: bank_iban,
          swift: bank_bic,
          email: user_email,
        )

        @errors << sup.errors.full_messages unless sup.valid?
      end
    end

    def customer_companies
      Company.where(yhtio: @customer_companies)
    end

    def supplier_companies
      Company.where(yhtio: @supplier_companies)
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

        new_user = User.create user

        if new_user.valid?
          new_user.update_permissions
        else
          @errors << new_user.errors.full_messages unless new_user.valid?
        end
      end
    end

    def update_nested_attributes
      Current.company = new_company

      new_company.assign_attributes(
        bank_accounts_attributes: bank_account_attributes,
        users_attributes: user_attributes,
      )

      @errors << new_company.errors.full_messages unless new_company.valid?

      new_company.save
    end

    def company_attributes
      @to_company_params.reject { |attribute| attribute.match(/_attributes$/) }
    end

    def bank_account_attributes
      accounts = @to_company_params.select { |p| p.match(/bank_accounts_attributes$/) }

      accounts[:bank_accounts_attributes] || []
    end

    def user_attributes
      users = @to_company_params.select { |p| p.match(/users_attributes$/) }

      users[:users_attributes] || []
    end

    def user_email
      user_attributes.blank? ? '' : user_attributes.first[:kuka]
    end

    def bank_iban
      bank_account_attributes.blank? ? '' : bank_account_attributes.first[:iban]
    end

    def bank_bic
      bank_account_attributes.blank? ? '' : bank_account_attributes.first[:bic]
    end

    def update_user_permissions
      Current.company = new_company

      # update permissions for all users
      new_company.users.find_each(&:update_permissions)
    end

    def write_css
      assets_before = compiled_assetes

      run_rake_tasks

      return if assets_before == compiled_assetes

      FileUtils.touch(Rails.root.join('tmp', 'restart.txt'))
    end

    def compiled_assetes
      Dir.glob('public/assets/**/*').hash
    end

    def run_rake_tasks
      Pupesoft::Application.load_tasks

      Rake::Task['css:write'].reenable
      Rake::Task['css:write'].invoke

      Rake::Task['assets:precompile'].reenable
      Rake::Task['assets:precompile'].invoke
    end
end
