class AddAlvVelvollinen < ActiveRecord::Migration
  def change
    add_column :yhtion_parametrit, :alv_velvollinen, :string, limit: 1, default: '', null: false, after: :alv_kasittely_hintamuunnos
  end
end
