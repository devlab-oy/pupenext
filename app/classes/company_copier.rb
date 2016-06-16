class CompanyCopier
  def initialize(company:, yhtio:, nimi:)
    @company = company
    @yhtio   = yhtio
    @nimi    = nimi
  end

  def copy
    raise 'Current company must be set' unless Current.company
    raise 'Current user must be set'    unless Current.user

    copied_company     = @company.dup
    copied_parameter   = @company.parameter.dup
    copied_currency    = @company.currencies.first.dup
    copied_menus       = @company.menus.map(&:dup)
    copied_profiles    = @company.profiles.map(&:dup)
    copied_user        = @company.users.find_by!(kuka: 'admin').dup
    copied_permissions = @company.users.find_by!(kuka: 'admin').permissions.map(&:dup)
    copied_sum_levels  = @company.sum_levels.map(&:dup)
    copied_accounts    = @company.accounts.map(&:dup)
    copied_keywords    = @company.keywords.map(&:dup)

    copied_company.update(
      yhtio: @yhtio,
      konserni: '',
      nimi: @nimi,
      laatija: Current.user.kuka,
      luontiaika: Time.now,
      muuttaja: Current.user.kuka,
      muutospvm: Time.now,
    )

    Current.company = copied_company

    copied_parameter.update(
      company: copied_company,
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
      laatija: Current.user.kuka,
      luontiaika: Time.now,
      muutospvm: Time.now,
      muuttaja: Current.user.kuka,
    )

    copied_currency.update(
      company: copied_company,
    )

    copied_menus.each do |menu|
      menu.update(
        company: copied_company,
        laatija: Current.user.kuka,
        luontiaika: Time.now,
        muutospvm: Time.now,
        muuttaja: Current.user.kuka,
      )
    end

    copied_profiles.each do |profile|
      profile.update(
        company: copied_company,
        laatija: Current.user.kuka,
        luontiaika: Time.now,
        muutospvm: Time.now,
        muuttaja: Current.user.kuka,
      )
    end

    copied_user.update(
      company: copied_company,
    )

    copied_permissions.each do |permission|
      permission.update(
        company: copied_company,
        user: copied_user,
      )
    end

    copied_sum_levels.each do |sum_level|
      sum_level.update(
        company: copied_company,
      )
    end

    copied_accounts.each do |account|
      account.update(
        company: copied_company,
      )
    end

    copied_keywords.each do |keyword|
      keyword.update(
        company: copied_company,
      )
    end

    copied_company
  end
end
