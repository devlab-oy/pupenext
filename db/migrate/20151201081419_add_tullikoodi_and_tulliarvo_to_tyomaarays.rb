require File.expand_path('test/permission_helper')
include PermissionHelper

class AddTullikoodiAndTulliarvoToTyomaarays < ActiveRecord::Migration
  def up
    add_column :tyomaarays, :tullikoodi, :string, limit: 8, default: '', null: false, after: :koodi
    add_column :tyomaarays, :tulliarvo, :decimal, precision: 12, scale: 2, default: 0.0, null: false, after: :tullikoodi
    add_column :tyomaarays, :maa_lahetys, :string, limit: 2, default: "", null: false, after: :tulliarvo
    add_column :tyomaarays, :maa_maara, :string, limit: 2, default: "", null: false, after: :maa_lahetys
    add_column :tyomaarays, :maa_alkupera, :string, limit: 2, default: "", null: false, after: :maa_maara
    add_column :tyomaarays, :kuljetusmuoto, :integer, limit: 1, default: 0, null: false, after: :maa_alkupera
    add_column :tyomaarays, :kauppatapahtuman_luonne, :integer, limit: 2, default: 0, null: false, after: :kuljetusmuoto
    add_column :tyomaarays, :bruttopaino, :decimal, precision: 8, scale: 2, default: 0.0, null: false, after: :kauppatapahtuman_luonne

    PermissionHelper.add_item(
      program: 'Vienti',
      name: 'Työmääräyksen lisätiedot',
      uri: 'tilauskasittely/vientitilauksen_lisatiedot.php',
      suburi: 'TYOMAARAYS'
    )
  end

  def down
    remove_column :tyomaarays, :tullikoodi
    remove_column :tyomaarays, :tulliarvo
    remove_column :tyomaarays, :maa_lahetys
    remove_column :tyomaarays, :maa_maara
    remove_column :tyomaarays, :maa_alkupera
    remove_column :tyomaarays, :kuljetusmuoto
    remove_column :tyomaarays, :kauppatapahtuman_luonne
    remove_column :tyomaarays, :bruttopaino

    PermissionHelper.remove_all(
      uri: 'tilauskasittely/vientitilauksen_lisatiedot.php',
      suburi: 'TYOMAARAYS'
    )
  end
end
