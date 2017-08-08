class AddLivetuotehakuHakutapaExtranetToYhtionParametrit < ActiveRecord::Migration
    def up
      add_column :yhtion_parametrit, :livetuotehaku_hakutapa_extranet, :char, default: '', null: false, after: :livetuotehaku_hakutapa
    end

    def down
      remove_column :yhtion_parametrit, :livetuotehaku_hakutapa_extranet
    end
  end
