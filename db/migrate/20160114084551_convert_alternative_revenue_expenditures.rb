class ConvertAlternativeRevenueExpenditures < ActiveRecord::Migration
  def up
    Company.find_each do |company|
      Current.company = company.yhtio

      keywords = Keyword::RevenueExpenditure.all

      keywords.each do |r|
        week, year = r.selite.split(' / ')
        selite = Date.commercial(year.to_i, week.to_i).strftime("%Y%V")
        r.update!(selite: selite)
      end
    end
  end

  def down
    Company.find_each do |company|
      Current.company = company.yhtio

      keywords = Keyword::RevenueExpenditure.all

      keywords.each do |r|
        selite = "#{r.selite[4..5]} / #{r.selite[0..3]}"
        r.update!(selite: selite)
      end
    end
  end
end
