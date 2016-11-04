class DropToimitustapaColumns < ActiveRecord::Migration
  def up
    remove_columns :toimitustapa, :kuljyksikko

    Company.find_each do |company|
      Current.company = company.yhtio
    end
  end
end
