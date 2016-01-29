class AddNoutopisteenTunnusColumnToLaskunLisatiedot < ActiveRecord::Migration
  def change
    add_column :laskun_lisatiedot, :noutopisteen_tunnus, :string, limit: 12, default: '', null: false, after: :ulkoinen_tarkenne
  end
end
