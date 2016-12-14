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

  def remove_all(uri:, suburi: '')
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: uri, alanimi: suburi).delete_all
      Menu.where(nimi: uri, alanimi: suburi).delete_all
      UserProfile.where(nimi: uri, alanimi: suburi).delete_all
    end
  end
end
