class AddStockListingMenu < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      # Luodaan valikko
      Permission.create!(
        kuka: '',
        sovellus: 'Varastoraportit',
        nimi: 'pupenext/stock_listing_csv',
        nimitys: 'Varastosaldot CSV',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 210
      )

      # Lisätään Admin profiiliin
      Permission.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: 'Varastoraportit',
        nimi: 'pupenext/stock_listing_csv',
        nimitys: 'Varastosaldot CSV',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 210
      )

      # Lisätään Adminille käyttöoikeus
      admin = User.find_by(kuka: 'admin')

      if admin
        Permission.create!(
          kuka: 'admin',
          user_id: admin.tunnus,
          profiili: 'Admin profiili',
          paivitys: 1,
          sovellus: 'Varastoraportit',
          nimi: 'pupenext/stock_listing_csv',
          nimitys: 'Varastosaldot CSV',
          laatija: 'admin',
          luontiaika: DateTime.now,
          muuttaja: 'admin',
          muutospvm: DateTime.now,
          jarjestys: 210
        )
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/stock_listing_csv').delete_all
    end
  end
end
