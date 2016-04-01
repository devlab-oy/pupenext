class AddMainostekstiToLasku < ActiveRecord::Migration
  def change
    add_column :lasku, :mainosteksti, :text, after: :maksuteksti
  end
end
