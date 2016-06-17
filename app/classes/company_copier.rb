class CompanyCopier
  def initialize(yhtio:, nimi:)
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @yhtio = yhtio
    @nimi  = nimi
  end

  def copy
    @copied_company = duplicate(
      Current.company,
      attributes: {
        yhtio: @yhtio,
        konserni: '',
        nimi: @nimi,
      },
    )

    @copied_parameter = duplicate(
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
      }
    )

    @copied_currency          = duplicate(Current.company.currencies)
    @copied_menus             = duplicate(Current.company.menus)
    @copied_profiles          = duplicate(Current.company.profiles)
    @copied_user              = duplicate(Current.company.users.find_by!(kuka: 'admin'))
    @copied_permissions       = duplicate(Current.company.users.find_by!(kuka: 'admin').permissions)
    @copied_sum_levels        = duplicate(Current.company.sum_levels)
    @copied_accounts          = duplicate(Current.company.accounts)
    @copied_keywords          = duplicate(Current.company.keywords)
    @copied_printers          = duplicate(Current.company.printers)
    @copied_terms_of_payments = duplicate(Current.company.terms_of_payments)
    @copied_delivery_methods  = duplicate(Current.company.delivery_methods)
    @copied_warehouses        = duplicate(Current.company.warehouses)

    @copied_company
  end

  private

    def duplicate(records, attributes: {})
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
        copy.update!(attributes)

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
