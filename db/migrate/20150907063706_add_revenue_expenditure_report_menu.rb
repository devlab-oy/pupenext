class AddRevenueExpenditureReportMenu < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      # Luodaan valikko
      Permission.create!(
        kuka: '',
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure',
        nimitys: 'Kassavirta',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 145
      )

      Permission.create!(
        kuka: '',
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure_report_datum',
        nimitys: 'Kassavirta ylläpito',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 146
      )

      # Lisätään Admin profiiliin
      Permission.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure',
        nimitys: 'Kassavirta',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 145
      )

      Permission.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure_report_datum',
        nimitys: 'Kassavirta ylläpito',
        laatija: 'admin',
        luontiaika: DateTime.now,
        muuttaja: 'admin',
        muutospvm: DateTime.now,
        jarjestys: 146
      )

      # Lisätään Adminille käyttöoikeus
      admin = User.find_by(kuka: 'admin')

      if admin
        Permission.create!(
          kuka: 'admin',
          user_id: admin.tunnus,
          profiili: 'Admin profiili',
          paivitys: 1,
          sovellus: 'Ostoreskontra',
          nimi: 'pupenext/revenue_expenditure',
          nimitys: 'Kassavirta',
          laatija: 'admin',
          luontiaika: DateTime.now,
          muuttaja: 'admin',
          muutospvm: DateTime.now,
          jarjestys: 145
        )

        Permission.create!(
          kuka: 'admin',
          user_id: admin.tunnus,
          profiili: 'Admin profiili',
          paivitys: 1,
          sovellus: 'Ostoreskontra',
          nimi: 'pupenext/revenue_expenditure_report_datum',
          nimitys: 'Kassavirta ylläpito',
          laatija: 'admin',
          luontiaika: DateTime.now,
          muuttaja: 'admin',
          muutospvm: DateTime.now,
          jarjestys: 146
        )
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/revenue_expenditure').delete_all
      Permission.where(nimi: 'pupenext/revenue_expenditure_report_datum').delete_all
    end
  end
end
