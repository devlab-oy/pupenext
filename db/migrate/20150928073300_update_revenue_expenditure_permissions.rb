class UpdateRevenueExpenditurePermissions < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/revenue_expenditure_report_datum')
        .update_all(nimi: 'pupenext/revenue_expenditures')
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      Permission.where(nimi: 'pupenext/revenue_expenditures')
        .update_all(nimi: 'pupenext/revenue_expenditure_report_datum')
    end
  end
end
