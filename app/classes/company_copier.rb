class CompanyCopier
  def initialize(yhtio:, nimi:, company: nil)
    @original_current_company = Current.company

    @company = if company
                 Current.company = company
               else
                 Current.company
               end

    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @yhtio = yhtio
    @nimi  = nimi
    @user  = Current.company.users.find_by!(kuka: 'admin')

  ensure
    Current.company = @original_current_company
  end

  def copy
    Current.company = @company

    @copied_company = duplicate(Current.company, attributes: { yhtio: @yhtio, konserni: '', nimi: @nimi })
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
    duplicate(Current.company.keywords, validate: false)
    duplicate(Current.company.printers)
    duplicate(Current.company.terms_of_payments)
    duplicate(Current.company.delivery_methods)
    duplicate(Current.company.warehouses)

    @copied_company
  rescue ActiveRecord::RecordInvalid => e
    # TODO: This can be achieved much easier with a db transaction.
    #   When those are supported, this should be refactorred.
    return e.record unless defined?(@copied_company) && @copied_company

    Current.company = @copied_company

    Warehouse.delete_all
    DeliveryMethod.delete_all
    TermsOfPayment.delete_all
    Printer.delete_all
    Keyword.delete_all
    Account.delete_all
    SumLevel.delete_all
    Permission.delete_all
    Currency.delete_all
    Parameter.delete_all
    User.delete_all
    Current.company.destroy!

    return e.record
  ensure
    Current.company = @original_current_company
  end

  private

    def duplicate(records, attributes: {}, validate: true)
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
end
