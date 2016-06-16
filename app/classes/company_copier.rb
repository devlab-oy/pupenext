class CompanyCopier
  def initialize(company:, yhtio:, nimi:)
    @company = company
    @yhtio   = yhtio
    @nimi    = nimi
  end

  def copy
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    @copied_company           = @company.dup
    @copied_parameter         = @company.parameter.dup
    @copied_currency          = @company.currencies.first.dup
    @copied_menus             = @company.menus.map(&:dup)
    @copied_profiles          = @company.profiles.map(&:dup)
    @copied_user              = @company.users.find_by!(kuka: 'admin').dup
    @copied_permissions       = @company.users.find_by!(kuka: 'admin').permissions.map(&:dup)
    @copied_sum_levels        = @company.sum_levels.map(&:dup)
    @copied_accounts          = @company.accounts.map(&:dup)
    @copied_keywords          = @company.keywords.map(&:dup)
    @copied_printers          = @company.printers.map(&:dup)
    @copied_terms_of_payments = @company.terms_of_payments.map(&:dup)
    @copied_delivery_methods  = @company.delivery_methods.map(&:dup)
    @copied_warehouses        = @company.warehouses.map(&:dup)

    @copied_company.assign_attributes(
      yhtio: @yhtio,
      konserni: '',
      nimi: @nimi,
    )

    Current.company = @copied_company

    @copied_parameter.assign_attributes(
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
    )

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
