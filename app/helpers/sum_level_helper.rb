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

  def tyyppi_options
    SumLevel.child_class_names.map do |v, m|
      [ m.human_readable_type, v ]
    end
  end
end
