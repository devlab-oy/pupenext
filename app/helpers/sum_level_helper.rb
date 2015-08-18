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
end
