class PendingProductUpdatesPermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      # Luodaan valikko
      Permission.create!(
        kuka: '',
        sovellus: 'Tuotehallinta',
        nimi: 'pupenext/pending_product_updates',
        nimitys: 'Pending product updates',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 145
      )

      # Lisätään Admin profiiliin
      Permission.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: 'Tuotehallinta',
        nimi: 'pupenext/pending_product_updates',
        nimitys: 'Pending product updates',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 145
      )

      # Lisätään Adminille käyttöoikeus
      admin = User.find_by(kuka: 'admin')

      if admin
        Permission.create!(
          kuka: 'admin',
          user_id: admin.tunnus,
          profiili: 'Admin profiili',
          paivitys: 1,
          sovellus: 'Tuotehallinta',
          nimi: 'pupenext/pending_product_updates',
          nimitys: 'Pending product updates',
          laatija: 'admin',
          luontiaika: DateTime.now,
          muuttaja: 'admin',
          muutospvm: DateTime.now,
          jarjestys: 145
       )
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/pending_product_updates').delete_all
    end
  end
end
