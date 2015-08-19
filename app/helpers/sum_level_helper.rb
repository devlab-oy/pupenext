module SumLevelHelper
  ROOT = 'administration.sum_levels'

  def kumulatiivinen_options
    SumLevel.kumulatiivinens.map do |key,_|
      [ t("#{ROOT}.kumulatiivinen_options.#{key}"), key ]
    end
  end

  def kayttotarkoitus_options
    SumLevel.kayttotarkoitus.map do |key,_|
      [ t("#{ROOT}.kayttotarkoitus_options.#{key}"), key ]
    end
  end

  def sum_level_tyyppi_options
    SumLevel.child_class_names.map do |v, m|
      [ m.model_name.human, v ]
    end
  end

  def sisainen_taso_options
    SumLevel::Internal.all.map do |level|
      [ level.sum_level_name, level.taso ]
    end
  end

  def ulkoinen_taso_options
    SumLevel::External.all.map do |level|
      [ level.sum_level_name, level.taso ]
    end
  end

  def alv_taso_options
    SumLevel::Vat.all.map do |level|
      [ level.sum_level_name, level.taso ]
    end
  end

  def tulosseuranta_taso_options
    SumLevel::Profit.all.map do |level|
      [ level.sum_level_name, level.taso ]
    end
  end

  def evl_taso_options
    SumLevel::Commodity.all.map do |level|
      [ level.sum_level_name, level.taso ]
    end
  end
end
