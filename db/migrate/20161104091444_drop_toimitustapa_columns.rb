class DropToimitustapaColumns < ActiveRecord::Migration
  def up
    remove_columns :toimitustapa, :kuljyksikko
  end
end
