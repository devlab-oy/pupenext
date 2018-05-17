module PermissionHelper
  def add_item(program:, uri:, name:, suburi: '', hidden: '')
    Company.find_each do |company|
      Current.company = company.yhtio

      # Haetaan admin user
      admin = User.find_by(kuka: :admin)
      Current.user = admin

      jarjestys = Menu.where(sovellus: program).maximum(:jarjestys).to_i + 10

      # Luodaan valikko
      Menu.create!(
        sovellus: program,
        nimi: uri,
        alanimi: suburi,
        nimitys: name,
        hidden: hidden,
        jarjestys: jarjestys,
      )

      # Lisätään Admin profiiliin
      UserProfile.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: program,
        nimi: uri,
        alanimi: suburi,
        nimitys: name,
        hidden: hidden,
        jarjestys: jarjestys,
      )

      # Lisätään Adminille käyttöoikeus
      if admin
        Permission.create!(
          kuka: 'admin',
          user_id: admin.tunnus,
          paivitys: 1,
          sovellus: program,
          nimi: uri,
          alanimi: suburi,
          hidden: hidden,
          nimitys: name,
          jarjestys: jarjestys,
        )
      end
    end
  end

  def remove_all(uri:, suburi: '', program: '')
    Company.find_each do |company|
      Current.company = company.yhtio

      perm = Permission.where(nimi: uri, alanimi: suburi)
      menu = Menu.where(nimi: uri, alanimi: suburi)
      prof = UserProfile.where(nimi: uri, alanimi: suburi)

      if program.present?
        perm.where(sevellus: program)
        menu.where(sevellus: program)
        prof.where(sevellus: program)
      end

      perm.delete_all
      menu.delete_all
      prof.delete_all
    end
  end
end
