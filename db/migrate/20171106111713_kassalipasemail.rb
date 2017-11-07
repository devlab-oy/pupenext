class Kassalipasemail < ActiveRecord::Migration
  def change
    add_column :kassalipas, :email, :string, limit: 100, default: '', null: false, after: :toimipaikka
  end
end
