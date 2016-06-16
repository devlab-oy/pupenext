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

    Current.company = @copied_company

    update_basic_attributes(@copied_company)
    update_basic_attributes(@copied_parameter)
    update_basic_attributes(@copied_currency)
    @copied_menus.each { |menu| update_basic_attributes(menu, user: false) }
    @copied_profiles.each { |profile| update_basic_attributes(profile, user: false) }
    update_basic_attributes(@copied_user)
    @copied_permissions.each { |permission| update_basic_attributes(permission) }
    @copied_sum_levels.each { |sum_level| update_basic_attributes(sum_level) }
    @copied_accounts.each { |account| update_basic_attributes(account) }
    @copied_keywords.each { |keyword| update_basic_attributes(keyword) }
    @copied_printers.each { |printer| update_basic_attributes(printer) }
    @copied_terms_of_payments.each { |terms_of_payment| update_basic_attributes(terms_of_payment) }
    @copied_delivery_methods.each { |delivery_method| update_basic_attributes(delivery_method) }
    @copied_warehouses.each { |warehouse| update_basic_attributes(warehouse) }

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
        copy.assign_attributes(attributes)
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
