class CalendarLoppupvm < ActiveRecord::Migration
  def up
      Company.find_each do |company|
        Current.company = company.yhtio

        Calendar.where("pvmalku > 0 and pvmloppu = 0")
          .update_all('pvmloppu = date_add(pvmalku, INTERVAL 30 MINUTE)')
      end
    end
end
