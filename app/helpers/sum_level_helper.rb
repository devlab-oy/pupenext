module SumLevelHelper
  ROOT = 'administration.sum_levels'

  def kumulatiivinen_options
    SumLevel.kumulatiivinens.map do |key, value|
      [ t("#{ROOT}.kumulatiivinen_options.#{key}"), value ]
    end
  end

  def kayttotarkoitus_options
    SumLevel.kayttotarkoitus.map do |key, value|
      [ t("#{ROOT}.kayttotarkoitus_options.#{key}"), value ]
    end
  end
end
