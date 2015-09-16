class AddRevenueExpenditureReportMenu < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      # Luodaan valikko
      Permission.create!(
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure',
        nimitys: 'Kassavirta',
        jarjestys: 145
      )

      Permission.create!(
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure_report_datum',
        nimitys: 'Kassavirta ylläpito',
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
        jarjestys: 145
      )

      Permission.create!(
        kuka: 'Admin profiili',
        profiili: 'Admin profiili',
        paivitys: 1,
        sovellus: 'Ostoreskontra',
        nimi: 'pupenext/revenue_expenditure_report_datum',
        nimitys: 'Kassavirta ylläpito',
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
          jarjestys: 146
        )
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/revenue_expenditure').delete_all
    end
  end
end
