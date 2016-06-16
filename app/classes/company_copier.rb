class CompanyCopier
  def initialize(company:, yhtio:, nimi:)
    @company = company
    @yhtio   = yhtio
    @nimi    = nimi
  end

  def copy
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @copied_company = duplicate(
      @company,
      attributes: {
        yhtio: @yhtio,
        konserni: '',
        nimi: @nimi,
      },
    )

    @copied_parameter = duplicate(
      @company.parameter,
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

    @copied_currency          = duplicate(@company.currencies.first)
    @copied_menus             = duplicate(@company.menus)
    @copied_profiles          = duplicate(@company.profiles)
    @copied_user              = duplicate(@company.users.find_by!(kuka: 'admin'))
    @copied_permissions       = duplicate(@company.users.find_by!(kuka: 'admin').permissions)
    @copied_sum_levels        = duplicate(@company.sum_levels)
    @copied_accounts          = duplicate(@company.accounts)
    @copied_keywords          = duplicate(@company.keywords)
    @copied_printers          = duplicate(@company.printers)
    @copied_terms_of_payments = duplicate(@company.terms_of_payments)
    @copied_delivery_methods  = duplicate(@company.delivery_methods)
    @copied_warehouses        = duplicate(@company.warehouses)

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

        update_basic_attributes(copy)
        copy.update(attributes)

        Current.company = current_company

        copy
      end

      return_array ? copies : copies.first
    end

    def update_basic_attributes(model, user: true)
      model.company    = @copied_company   if model.respond_to?(:company=)
      model.user       = @copied_user      if user && model.respond_to?(:user=)
      model.laatija    = Current.user.kuka if model.respond_to?(:laatija=)
      model.luontiaika = Time.now          if model.respond_to?(:luontiaika=)
      model.muutospvm  = Time.now          if model.respond_to?(:muutospvm=)
      model.muuttaja   = Current.user.kuka if model.respond_to?(:muuttaja=)

      model.save
    end
end
