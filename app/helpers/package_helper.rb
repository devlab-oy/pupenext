module PackageHelper
  ROOT = 'administration.packages'

  def rahtivapaa_veloitus_options
    Package.rahtivapaa_veloitus.map do |key,_|
      [ t("#{ROOT}.rahtivapaa_veloitus_options.#{key}"), key ]
    end
  end

  def erikoispakkaus_options
    Package.erikoispakkaus.map do |key,_|
      [ t("#{ROOT}.erikoispakkaus_options.#{key}"), key ]
    end
  end

  def yksin_eraan_options
    Package.yksin_eraans.map do |key,_|
      [ t("#{ROOT}.yksin_eraan_options.#{key}"), key ]
    end
  end
end
