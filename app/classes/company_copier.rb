class CompanyCopier
  def initialize(from_company: nil, to_company_params: {}, create_as_customer_to_ids: [])
    @original_current_company = Current.company
    @from_company = from_company ? Current.company = from_company : Current.company

    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    to_company_params = to_company_params.merge(konserni: '', nimi: '') { |_k, o, n| o.nil? ? n : o }

    @to_company_params     = to_company_params.reject { |attribute| attribute.match(/_attributes$/) }
    @association_params    = to_company_params.select { |attribute| attribute.match(/_attributes$/) }
    @user                  = Current.company.users.find_by!(kuka: 'admin')
    @create_as_customer_to = create_as_customer_to_ids ? Company.find(create_as_customer_to_ids) : []
  ensure
    Current.company = @original_current_company
  end

  def copy
    Current.company = @from_company

    @copied_company = duplicate(Current.company, attributes: @to_company_params, validate: true)
    @copied_user    = duplicate(@user)

    duplicate(
      Current.company.parameter,
      attributes: {
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
      },
    )
    duplicate(Current.company.currencies)
    duplicate(Current.company.menus)
    duplicate(Current.company.profiles)
    duplicate(@user.permissions)
    duplicate(Current.company.sum_levels)
    duplicate(Current.company.accounts)
    duplicate(Current.company.keywords)
    duplicate(Current.company.printers)
    duplicate(Current.company.terms_of_payments)
    duplicate(Current.company.delivery_methods)
    duplicate(Current.company.warehouses)

    copy_association_attributes

    create_as_customer_to_specified_companies_with_extranet_users

    @copied_company
  rescue ActiveRecord::RecordInvalid => e
    return e.record unless defined?(@copied_company) && @copied_company

    delete_partial_data

    return e.record
  rescue
    raise unless defined?(@copied_company) && @copied_company

    delete_partial_data

    raise
  ensure
    Current.company = @original_current_company
  end

  private

    def duplicate(records, attributes: {}, validate: false)
      return_array = true

      unless records.respond_to?(:map)
        records      = [records]
        return_array = false
      end

      copies = records.map do |record|
        copy = record.dup

        current_company = Current.company
        Current.company = @copied_company

        assign_basic_attributes(copy)
        copy.assign_attributes(attributes)
        copy.save!(validate: validate)

        Current.company = current_company

        copy
      end

      return_array ? copies : copies.first
    end

    def assign_basic_attributes(model)
      model.company    = Current.company   if model.respond_to?(:company=)
      model.user       = @copied_user      if model.respond_to?(:user=)
      model.laatija    = Current.user.kuka if model.respond_to?(:laatija=)
      model.luontiaika = Time.now          if model.respond_to?(:luontiaika=)
      model.muutospvm  = Time.now          if model.respond_to?(:muutospvm=)
      model.muuttaja   = Current.user.kuka if model.respond_to?(:muuttaja=)
    end

    def copy_association_attributes(validate: false)
      @copied_company.assign_attributes(@association_params)
      @copied_company.save!(validate: validate)
    end

    def create_as_customer_to_specified_companies_with_extranet_users
      @create_as_customer_to.each do |company|
        Current.company = company

        Customer.create!(
          nimi: @copied_company.nimi,
          ytunnus: @copied_company.ytunnus,
          kauppatapahtuman_luonne: Keyword::NatureOfTransaction.first.selite,
          alv: Keyword::Vat.first.selite,
        )

        next unless @association_params[:users_attributes]

        @association_params[:users_attributes].each do |user_params|
          user_params.merge!(
            kuka: "#{user_params[:kuka]}extra",
            extranet: 'X',
            profiilit: 'Extranet',
            oletus_profiili: 'Extranet',
          )

          User.create!(user_params)
        end
      end
    end

    # TODO: This can be achieved much easier with a db transaction.
    #   When those are supported, this should be refactored.
    def delete_partial_data
      Current.company = @copied_company

      Warehouse.destroy_all
      DeliveryMethod.destroy_all
      TermsOfPayment.destroy_all
      Printer.destroy_all
      Keyword.destroy_all
      BankAccount.destroy_all
      Account.destroy_all
      SumLevel.destroy_all
      Permission.destroy_all
      Currency.destroy_all
      Parameter.destroy_all
      User.destroy_all
      Current.company.destroy!
    end
end
